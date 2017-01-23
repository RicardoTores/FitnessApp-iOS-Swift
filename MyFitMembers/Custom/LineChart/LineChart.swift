


import UIKit
import QuartzCore

// delegate method
public protocol LineChartDelegate {
    func didSelectDataPoint(x: CGFloat, yValues: [CGFloat])
    func selectedData(date: String)
}
var fromWeighIn = false
/**
 * LineChart
 */
public class LineChart: UIView {
    
    /**
     * Helpers class
     */
    private class Helpers {
        
        /**
         * Convert hex color to UIColor
         */
        private class func UIColorFromHex(hex: Int) -> UIColor {
            let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((hex & 0xFF)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        /**
         * Lighten color.
         */
        private class func lightenUIColor(color: UIColor) -> UIColor {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
        }
    }
    
    public struct Labels {
        public var visible: Bool = true
        public var values: [String] = []
    }
    
    public struct Grid {
        public var visible: Bool = true
        public var count: CGFloat = 10
        // #eeeeee
        public var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    }
    
    public struct Axis {
        public var visible: Bool = true
        // #607d8b
        public var color: UIColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1)
        public var inset: CGFloat = 36
    }
    public struct Coordinate {
        // public
        public var labels: Labels = Labels()
        public var grid: Grid = Grid()
        public var axis: Axis = Axis()
        
        // private
        private var linear: LinearScale!
        private var scale: ((CGFloat) -> CGFloat)!
        private var invert: ((CGFloat) -> CGFloat)!
        private var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    public struct Animation {
        public var enabled: Bool = true
        public var duration: CFTimeInterval = 1
    }
    
    public struct Dots {
        public var visible: Bool = true
        public var color: UIColor = UIColor.clearColor()
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    // default configuration
    public var area: Bool = true
    public var animation: Animation = Animation()
    public var dots: Dots = Dots()
    public var lineWidth: CGFloat = 2
    
    public var x1: Coordinate = Coordinate()
    public var y1: Coordinate = Coordinate()
    
    
    // values calculated on init
    private var drawingHeight: CGFloat = 0 {
        didSet {
            let max = getMaximumValue()
            let min = getMinimumValue()
            y1.linear = LinearScale(domain: [min, max], range: [0, drawingHeight])
            y1.scale = y1.linear.scale()
            y1.ticks = y1.linear.ticks(Int(y1.grid.count))
        }
    }
    private var drawingWidth: CGFloat = 0 {
        didSet {
            let data = dataStore[0]
            x1.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x1.scale = x1.linear.scale()
            x1.invert = x1.linear.invert()
            x1.ticks = x1.linear.ticks(Int(x1.grid.count))
        }
    }
    
    public var delegate: LineChartDelegate?
    
    
    
    // data stores
    private var dataStore: [[CGFloat]] = []
    private var dotsDataStore: [[DotCALayer]] = []
    private var lineLayerStore: [CAShapeLayer] = []
    
    private var removeAll: Bool = false
    
    
    
    // category10 colors from d3 - https://github.com/mbostock/d3/wiki/Ordinal-Scales
    public var colors: [UIColor] = [
        UIColor(red: 238/255, green: 40/255, blue: 62/255, alpha: 1),
        UIColor(red: 238/255, green: 207/255, blue: 40/255, alpha: 1),
        UIColor(red: 40/255, green: 157/255, blue: 238/255, alpha: 1),
        UIColor(red: 88/255, green: 238/255, blue: 40/255, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            CGContextClearRect(context, rect)
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y1.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x1.axis.inset)
        
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        dotsDataStore.removeAll()
        
        // draw grid
        if x1.grid.visible && y1.grid.visible { drawGrid() }
        
        // draw axes
        if x1.axis.visible && y1.axis.visible { drawAxes() }
        
        // draw labels
        if x1.labels.visible { drawXLabels() }
        if y1.labels.visible { drawYLabels() }
        
        // draw lines
        for (lineIndex, _) in dataStore.enumerate() {
            
            drawLine(lineIndex)
            
            // draw dots
            if dots.visible { drawDataDots(lineIndex) }
            
            // draw area under line chart
            if area { drawAreaBeneathLineChart(lineIndex) }
            
        }
        
    }
    
    
    
    /**
     * Get y value for given x value. Or return zero or maximum value.
     */
    private func getYValuesForXValue(x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    
    
    /**
     * Handle touch events.
     */
    private func handleTouchEvents(touches: NSSet!, event: UIEvent) {
        if (self.dataStore.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject()
        let xValue = point.locationInView(self).x
        let inverted = self.x1.invert(xValue - x1.axis.inset)
        let rounded = Int(round(Double(inverted)))
        let yValues: [CGFloat] = getYValuesForXValue(rounded)
        highlightDataPoints(rounded)
        delegate?.didSelectDataPoint(CGFloat(rounded), yValues: yValues)
    }
    
    
    
    /**
     * Listen on touch end event.
     */
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouchEvents(touches, event: event!)
    }
    
    
    
    /**
     * Listen on touch move event
     */
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouchEvents(touches, event: event!)
    }
    
    
    
    /**
     * Highlight data points at index.
     */
    private func highlightDataPoints(index: Int) {
        //        for (lineIndex, dotsData) in dotsDataStore.enumerate() {
        //            // make all dots white again
        //            for dot in dotsData {
        //                dot.backgroundColor = dots.color.CGColor
        //            }
        //            // highlight current data point
        //            var dot: DotCALayer
        //            if index < 0 {
        //                dot = dotsData[0]
        //            } else if index > dotsData.count - 1 {
        //                dot = dotsData[dotsData.count - 1]
        //            } else {
        //                dot = dotsData[index]
        //            }
        //            dot.backgroundColor = Helpers.lightenUIColor(colors[lineIndex]).CGColor
        //        }
    }
    
    
    
    /**
     * Draw small dot at every data point.
     */
    private func drawDataDots(lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        var data = self.dataStore[lineIndex]
        
        for index in 0..<data.count {
            let xValue = self.x1.scale(CGFloat(index)) + x1.axis.inset - dots.outerRadius/2
            let yValue = self.bounds.height - self.y1.scale(data[index]) - y1.axis.inset - dots.outerRadius/2
            
            // draw custom layer with another layer in the center
            let dotLayer = DotCALayer()
            dotLayer.dotInnerColor = colors[lineIndex]
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = dots.color.CGColor
            dotLayer.cornerRadius = dots.outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
            
            // animate opacity
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                dotLayer.addAnimation(anim, forKey: "opacity")
            }
            
        }
        dotsDataStore.append(dotLayers)
    }
    
    
    
    /**
     * Draw x and y axis.
     */
    private func drawAxes() {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        // draw x-axis
        x1.axis.color.setStroke()
        let y0 = height - self.y1.scale(0) - y1.axis.inset
        path.lineWidth = 2.0
        path.moveToPoint(CGPoint(x: x1.axis.inset, y: y0))
        path.addLineToPoint(CGPoint(x: width - x1.axis.inset, y: y0))
        path.stroke()
        // draw y-axis
        //        y.axis.color.setStroke()
        //        path.moveToPoint(CGPoint(x: x.axis.inset, y: height - y.axis.inset))
        //        path.addLineToPoint(CGPoint(x: x.axis.inset, y: y.axis.inset))
        //        path.stroke()
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    private func getMaximumValue() -> CGFloat {
        var max: CGFloat = 1
        for data in dataStore {
            let newMax = data.maxElement()!
            if newMax > max {
                max = newMax
            }
        }
        return max
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    private func getMinimumValue() -> CGFloat {
        var min: CGFloat = 0
        for data in dataStore {
            let newMin = data.minElement()!
            if newMin < min {
                min = newMin
            }
        }
        return min
    }
    
    
    
    /**
     * Draw line.
     */
    private func drawLine(lineIndex: Int) {
        
        var data = self.dataStore[lineIndex]
        let path = UIBezierPath()
        
        var xValue = self.x1.scale(0) + x1.axis.inset
        var yValue = self.bounds.height - self.y1.scale(data[0]) - y1.axis.inset
        path.moveToPoint(CGPoint(x: xValue, y: yValue))
        for index in 1..<data.count {
            xValue = self.x1.scale(CGFloat(index)) + x1.axis.inset
            yValue = self.bounds.height - self.y1.scale(data[index]) - y1.axis.inset
            path.addLineToPoint(CGPoint(x: xValue, y: yValue))
        }
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.CGPath
        layer.strokeColor = colors[lineIndex].CGColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
        
        // animate line drawing
        if animation.enabled {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = animation.duration
            anim.fromValue = 0
            anim.toValue = 1
            layer.addAnimation(anim, forKey: "strokeEnd")
        }
        
        // add line layer to store
        lineLayerStore.append(layer)
    }
    
    
    
    /**
     * Fill area between line chart and x-axis.
     */
    private func drawAreaBeneathLineChart(lineIndex: Int) {
        
        //        var data = self.dataStore[lineIndex]
        //        let path = UIBezierPath()
        //
        //        colors[lineIndex].colorWithAlphaComponent(0.2).setFill()
        //        // move to origin
        //        path.moveToPoint(CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        //        // add line to first data point
        //        path.addLineToPoint(CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(data[0]) - y.axis.inset))
        //        // draw whole line chart
        //        for index in 1..<data.count {
        //            let x1 = self.x.scale(CGFloat(index)) + x.axis.inset
        //            let y1 = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
        //            path.addLineToPoint(CGPoint(x: x1, y: y1))
        //        }
        //        // move down to x axis
        //        path.addLineToPoint(CGPoint(x: self.x.scale(CGFloat(data.count - 1)) + x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        //        // move to origin
        //        path.addLineToPoint(CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        //        path.fill()
    }
    
    
    
    /**
     * Draw x grid.
     */
    private func drawXGrid() {
        x1.grid.color.setStroke()
        let path = UIBezierPath()
        var x11: CGFloat
        let y11: CGFloat = self.bounds.height - y1.axis.inset
        let y2: CGFloat = y1.axis.inset
        let (start, stop, step) = self.x1.ticks
        for var i: CGFloat = start; i <= stop; i += step {
            x11 = self.x1.scale(i) + x1.axis.inset
            path.moveToPoint(CGPoint(x: x11, y: y11))
            path.addLineToPoint(CGPoint(x: x11, y: y2))
        }
        path.stroke()
    }
    
    
    
    /**
     * Draw y grid.
     */
    private func drawYGrid() {
        self.y1.grid.color.setStroke()
        let path = UIBezierPath()
        let x12: CGFloat = x1.axis.inset
        let x2: CGFloat = self.bounds.width - x1.axis.inset
        var y11: CGFloat
        let (start, stop, step) = self.y1.ticks
        for var i: CGFloat = start; i <= stop; i += step {
            y11 = self.bounds.height - self.y1.scale(i) - y1.axis.inset
            path.moveToPoint(CGPoint(x: x12, y: y11))
            path.addLineToPoint(CGPoint(x: x2, y: y11))
        }
        path.stroke()
    }
    
    
    
    /**
     * Draw grid.
     */
    private func drawGrid() {
        //        drawXGrid()
        //        drawYGrid()
    }
    
    
    
    /**
     * Draw x labels.
     */
    
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    var floatingLabel: UIButton?
    var weighInView: WeighInView?
    var shapeLayerGlobal = CAShapeLayer()
    var globalPath = UIBezierPath()
    var labelForFirstVal: UILabel?
    
    private func drawXLabels() {
        createLabel()
        
        let xAxisData = self.dataStore[0]
        let y = self.bounds.height - x1.axis.inset
        let (_, _, step) = x1.linear.ticks(xAxisData.count)
        let width = x1.scale(step)
        
        var text: String
        for (index, _) in xAxisData.enumerate() {
            
            let xValue = self.x1.scale(CGFloat(index)) + x1.axis.inset - (width / 2)
            let rect = CGRect(x: xValue, y: y+4, width: width, height: x1.axis.inset)
            let hiddenLabel = UILabel(frame: CGRect(x: xValue, y: y, width: width, height: x1.axis.inset))
            hiddenLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
            hiddenLabel.textAlignment = .Center
            let label = UILabel(frame: rect)
            label.textAlignment = .Center
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 10.0)
            label.textColor = Colorss.CalendarGreyColor.toHex()
            print(x1.labels.values.count)
            if (x1.labels.values.count != 0) {
                text = x1.labels.values[index]
            } else {
                text = String(index)
            }
            label.textColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 0.88)
            label.text = text
            
            
            let path1 = UIBezierPath()
            path1.moveToPoint(CGPoint(x: label.frame.width/2 + xValue+1, y: y))
            path1.addLineToPoint(CGPoint(x: label.frame.width/2 + xValue+1,y: y-10))
            let shapeLayer1 = CAShapeLayer()
            shapeLayer1.path = path.CGPath
            shapeLayer1.strokeColor = Colorss.LinChartGreyColor.toHex().CGColor
            shapeLayer1.lineWidth = 2.0
            self.layer.addSublayer(shapeLayer1)
            
            //show grid of x axis
            
            
            let gridPath = UIBezierPath()
            
            gridPath.moveToPoint(CGPoint(x: label.frame.width/2 + xValue, y: y))
            gridPath.addLineToPoint(CGPoint(x: label.frame.width/2 + xValue,y: y-10))
            let gridShapeLayer = CAShapeLayer()
            gridShapeLayer.path = gridPath.CGPath
            gridShapeLayer.strokeColor = Colorss.LinChartGreyColor.toHex().CGColor
            gridShapeLayer.lineWidth = 2.0
            self.layer.addSublayer(gridShapeLayer)
            
            if fromWeighIn{
                if index == 1{
                    self.floatingLabel?.hidden = false
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.titleLabel?.textColor = UIColor.whiteColor()
                    self.floatingLabel?.clipsToBounds = true
                    let x = label.frame.width/2 + xValue
                    self.floatingLabel?.frame = CGRect(x: x-15 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.bringSubviewToFront(self.floatingLabel ?? UIView())
                    var data = self.dataStore[0]
                    let xValue = self.x1.scale(CGFloat(index)) + self.x1.axis.inset - self.dots.outerRadius/2
                    let yValue = self.bounds.height - self.y1.scale(data[index]) - self.y1.axis.inset - self.dots.outerRadius/2
                    print("\(data[index])" + "kg")
                    
                    self.weighInView?.spring(animations: {
                        self.weighInView?.frame = CGRectMake(xValue - 12, yValue - 48, 36.0, 48.0)
                         var units = NSUserDefaults.standardUserDefaults().valueForKey("GraphUnitsClient") as? [String] ?? []
                        if units.count > 0 {
                            let unit = units[index]
                            self.weighInView?.labelWeight.text = "\(data[index])" + " " + unit
                        }else{
                            
                            self.weighInView?.labelWeight.text = ""
                        }
                        
                        self.weighInView?.hidden = false
                    })
                }else{
                    
                }}else{
                
                if index == 1{
                    self.globalPath = UIBezierPath()
                    self.shapeLayerGlobal.path = self.globalPath.CGPath
                    let x = label.frame.width/2 + xValue
                    self.globalPath.moveToPoint(CGPoint(x: x,y: y))
                    let vwrame = self.frame.height - 64
                    self.globalPath.addLineToPoint(CGPoint(x: x,y: y - vwrame))
                    self.shapeLayerGlobal.path = self.globalPath.CGPath
                    self.shapeLayerGlobal.strokeColor = Colorss.DarkRed.toHex().CGColor
                    self.shapeLayerGlobal.lineDashPattern = [4,4]
                    self.shapeLayerGlobal.lineWidth = 2.0
                    self.floatingLabel?.hidden = false
                    self.layer.addSublayer(self.shapeLayerGlobal)
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.frame = CGRect(x: x-16 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.delegate?.selectedData(label.text ?? "")
                }else{
                    
                }
            }
            
            hiddenLabel.addSingleTapGestureRecognizerWithResponder({ [unowned
                self] (tap) in
                
                if fromWeighIn{
                    self.floatingLabel?.hidden = false
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.titleLabel?.textColor = UIColor.whiteColor()
                    self.floatingLabel?.clipsToBounds = true
                    let x = label.frame.width/2 + xValue
                    self.floatingLabel?.frame = CGRect(x: x-15 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.bringSubviewToFront(self.floatingLabel ?? UIView())
                    var data = self.dataStore[0]
                    let xValue = self.x1.scale(CGFloat(index)) + self.x1.axis.inset - self.dots.outerRadius/2
                    let yValue = self.bounds.height - self.y1.scale(data[index]) - self.y1.axis.inset - self.dots.outerRadius/2
                    
                    self.weighInView?.spring(animations: {
                        self.weighInView?.frame = CGRectMake(xValue - 12, yValue - 48, 36.0, 48.0)
                        self.weighInView?.hidden = false
                         var units = NSUserDefaults.standardUserDefaults().valueForKey("GraphUnitsClient") as? [String]  ?? []
                        if units.count > 0 {
                            let unit = units[index]
                            self.weighInView?.labelWeight.text = "\(data[index])" + " " + unit
                        }else{
                            
                            self.weighInView?.labelWeight.text = ""
                        }
                       
                    })
                    
                }else{
                    self.path = UIBezierPath()
                    self.shapeLayer.path = self.path.CGPath
                    let x = label.frame.width/2 + xValue
                    self.path.moveToPoint(CGPoint(x: x,y: y))
                    let vwrame = self.frame.height - 64
                    self.path.addLineToPoint(CGPoint(x: x,y: y - vwrame))
                    self.shapeLayer.path = self.path.CGPath
                    self.shapeLayer.strokeColor = Colorss.DarkRed.toHex().CGColor
                    self.shapeLayer.lineDashPattern = [4,4]
                    self.shapeLayer.lineWidth = 2.0
                    self.floatingLabel?.hidden = false
                    self.layer.addSublayer(self.shapeLayer)
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.frame = CGRect(x: x-16 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.delegate?.selectedData(label.text ?? "")
                    self.shapeLayerGlobal.hidden = true
                }
                })
            
            
            if x1.labels.values.count == 1{
                createLabelForOne()
                let x = label.frame.width/2 + xValue
                self.labelForFirstVal?.frame = CGRect(x: x-16 , y:y+6 , width: 32, height: 32)
                guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                self.labelForFirstVal?.textColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 0.88)
                self.labelForFirstVal?.font = avenierFont
                self.labelForFirstVal?.text = x1.labels.values[index]
                
                self.bringSubviewToFront(labelForFirstVal ?? UIView())
                
                
                if fromWeighIn{
                    floatingLabel?.backgroundColor = Colorss.DarkRed.toHex()
                    self.floatingLabel?.hidden = false
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.titleLabel?.textColor = UIColor.whiteColor()
                    self.floatingLabel?.clipsToBounds = true
                    let x = label.frame.width/2 + xValue
                    self.floatingLabel?.frame = CGRect(x: x-15 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.bringSubviewToFront(self.floatingLabel ?? UIView())
                    var data = self.dataStore[0]
                    let xValue = self.x1.scale(CGFloat(index)) + self.x1.axis.inset - self.dots.outerRadius/2
                    let yValue = self.bounds.height - self.y1.scale(data[index]) - self.y1.axis.inset - self.dots.outerRadius/2
                    self.weighInView?.spring(animations: {
                        self.weighInView?.frame = CGRectMake(xValue - 12, yValue - 48, 36.0, 48.0)
                        self.weighInView?.hidden = false
                         var units = NSUserDefaults.standardUserDefaults().valueForKey("GraphUnitsClient") as? [String] ?? []
                        if units.count > 0 {
                            let unit = units[index]
                            self.weighInView?.labelWeight.text = "\(data[index])" + " " + unit
                        }else{
                            
                            self.weighInView?.labelWeight.text = ""
                        }
                        
                        
                    })
                    self.addSubview(self.floatingLabel ?? UIView())
                }else{
                    self.path = UIBezierPath()
                    self.shapeLayer.path = self.path.CGPath
                    let x = label.frame.width/2 + xValue
                    self.path.moveToPoint(CGPoint(x: x,y: y))
                    let vwrame = self.frame.height - 64
                    self.path.addLineToPoint(CGPoint(x: x,y: y - vwrame))
                    self.shapeLayer.path = self.path.CGPath
                    self.shapeLayer.strokeColor = Colorss.DarkRed.toHex().CGColor
                    self.shapeLayer.lineDashPattern = [4,4]
                    self.shapeLayer.lineWidth = 2.0
                    self.floatingLabel?.hidden = false
                    self.layer.addSublayer(self.shapeLayer)
                    self.floatingLabel?.setTitle(label.text, forState: .Normal)
                    guard let avenierFont = UIFont(name: "AvenirNext-DemiBold", size: 10.0) else {return}
                    self.floatingLabel?.titleLabel?.font = avenierFont
                    self.floatingLabel?.frame = CGRect(x: x-16 , y:y+6 , width: 32, height: 32)
                    self.floatingLabel?.layer.cornerRadius = (self.floatingLabel?.frame.height ?? 0)/2
                    self.delegate?.selectedData(label.text ?? "")
                    self.shapeLayerGlobal.hidden = true
                    self.addSubview(self.floatingLabel ?? UIView())
                }
                
                
                
            }else{
                
                
                hiddenLabel.userInteractionEnabled = true
                self.addSubview(label)
                self.addSubview(hiddenLabel)
                self.addSubview(floatingLabel ?? UIView())
                
            }
            
            
        }
        
    }
    
    
    
    /**
     * Draw y labels.
     */
    private func drawYLabels() {
        var yValue: CGFloat
        let (start, stop, step) = self.y1.ticks
        for var i: CGFloat = start; i <= stop; i += step {
            yValue = self.bounds.height - self.y1.scale(i) - (y1.axis.inset * 1.5)
            let label = UILabel(frame: CGRect(x: 0, y: yValue, width: y1.axis.inset, height: y1.axis.inset))
            label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
            label.textAlignment = .Center
            label.text = String(Int(round(i)))
            self.addSubview(label)
        }
    }
    
    //MARK::- Create floating Label
    
    func createLabel(){
        floatingLabel = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        floatingLabel?.layer.cornerRadius = (floatingLabel?.frame.height ?? 0)/2
        floatingLabel?.clipsToBounds = true
        floatingLabel?.backgroundColor = Colorss.DarkRed.toHex()
        floatingLabel?.hidden = true
        floatingLabel?.layer.borderWidth = 2.0
        floatingLabel?.clipsToBounds = true
        floatingLabel?.layer.borderColor = Colorss.DarkRed.toHex().CGColor
        weighInView = WeighInView(frame: CGRectMake(0, 0, 32.0, 40.0))
        self.addSubview(weighInView ?? UIView())
        weighInView?.hidden = true
        print(weighInView)
        
    }
    
    func createLabelForOne(){
        
        labelForFirstVal = UILabel(frame: CGRect(x: 0, y: 0, w: 24, h: 24))
        labelForFirstVal?.textAlignment = .Center
        labelForFirstVal?.backgroundColor = UIColor.clearColor()
        self.addSubview(labelForFirstVal ?? UIView())
    }
    
    
    /**
     * Add line chart
     */
    public func addLine(data: [CGFloat]) {
        print(data)
        self.dataStore.append(data)
        self.setNeedsDisplay()
    }
    
    
    
    /**
     * Make whole thing white again.
     */
    public func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    
    
    /**
     * Remove charts, areas and labels but keep axis and grid.
     */
    public func clear() {
        // clear data
        dataStore.removeAll()
        self.setNeedsDisplay()
    }
}



/**
 * DotCALayer
 */
class DotCALayer: CALayer {
    
    var innerRadius: CGFloat = 4
    var dotInnerColor = UIColor.blackColor()
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - innerRadius
        let innerDotLayer = CALayer()
        innerDotLayer.frame = CGRectInset(self.bounds, inset/2, inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.CGColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
    
}



/**
 * LinearScale
 */
public class LinearScale {
    
    var domain: [CGFloat]
    var range: [CGFloat]
    
    public init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
        self.domain = domain
        self.range = range
    }
    
    public func scale() -> (x: CGFloat) -> CGFloat {
        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    public func invert() -> (x: CGFloat) -> CGFloat {
        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    public func ticks(m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTicks(domain, m: m)
    }
    
    private func scale_linearTicks(domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTickRange(domain, m: m)
    }
    
    private func scale_linearTickRange(domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        var extent = scaleExtent(domain)
        let span = extent[1] - extent[0]
        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
        let err = CGFloat(m) / span * step
        
        // Filter ticks to get closer to the desired count.
        if (err <= 0.15) {
            step *= 10
        } else if (err <= 0.35) {
            step *= 5
        } else if (err <= 0.75) {
            step *= 2
        }
        
        // Round start and stop values to step interval.
        let start = ceil(extent[0] / step) * step
        let stop = floor(extent[1] / step) * step + step * 0.5 // inclusive
        
        return (start, stop, step)
    }
    
    private func scaleExtent(domain: [CGFloat]) -> [CGFloat] {
        let start = domain[0]
        let stop = domain[domain.count - 1]
        return start < stop ? [start, stop] : [stop, start]
    }
    
    private func interpolate(a: CGFloat, b: CGFloat) -> (c: CGFloat) -> CGFloat {
        var diff = b - a
        func f(c: CGFloat) -> CGFloat {
            return (a + diff) * c
        }
        return f
    }
    
    private func uninterpolate(a: CGFloat, b: CGFloat) -> (c: CGFloat) -> CGFloat {
        var diff = b - a
        var re = diff != 0 ? 1 / diff : 0
        func f(c: CGFloat) -> CGFloat {
            return (c - a) * re
        }
        return f
    }
    
    private func bilinear(domain: [CGFloat], range: [CGFloat], uninterpolate: (a: CGFloat, b: CGFloat) -> (c: CGFloat) -> CGFloat, interpolate: (a: CGFloat, b: CGFloat) -> (c: CGFloat) -> CGFloat) -> (c: CGFloat) -> CGFloat {
        var u: (c: CGFloat) -> CGFloat = uninterpolate(a: domain[0], b: domain[1])
        var i: (c: CGFloat) -> CGFloat = interpolate(a: range[0], b: range[1])
        func f(d: CGFloat) -> CGFloat {
            return i(c: u(c: d))
        }
        return f
    }
    
}