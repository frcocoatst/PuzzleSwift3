//
//  MyView.swift
//  PuzzleSwift
//
//  Created by Friedrich HAEUPL on 10.05.16.
//  Copyright © 2016 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

var de: Element = Element(index: 1, color: 0)                   // default element
var board: [[Element]] = [[de,de,de,de],[de,de,de,de],[de,de,de,de],[de,de,de,de]]     // 4*4 Matrix

class MyView: NSView{
    
    
    var blankX: Int = 0
    var blankY: Int = 0
    var scrambled:Bool = false
    
    
    // see http://blog.scottlogic.com/2014/11/20/swift-initialisation.html
    // see http://stackoverflow.com/questions/32486914/xcode-swift-nsview-not-being-called/32487762#32487762
    
    //initialize various points
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        //fatalError("init(coder:) has not been implemented")
        commonInitializer()
    }
    
    
    func commonInitializer() {
        // initialize globals
        scrambled = false
        blankX  = 0
        blankY  = 0
        
        board[3][3].index = -1
        blankX = 3
        blankY = 3
        
        //for (int i=0; i<15; i++)
        for i in 0...15
        {
            let col:Int = i%4
            let row:Int = i/4
            let color:Int = (col + row)%2
            
            board[col][row].index = i+1
            board[col][row].color = color
        }
        board[3][3].index = -1
        board[3][3].color = 0

        NSLog("%d",board[1][1].index)
    }
    
    
    // drawRect
    
    
    override func draw(_ dirtyRect: NSRect)
    {
        // Examples are taken from:
        
        NSColor.white.setFill()
        NSRectFill(self.bounds)
        //
        super.draw(dirtyRect)
        //
        // self.doIt()
        
        for col in 0..<4 {
            //for (col = 0; col < 4; col++)
            for row in 0..<4 {
                //for(row = 0; row < 4; row++)
                
                let tileRect:NSRect = NSMakeRect(CGFloat(col) * 100.0 ,
                                                 CGFloat(row) * 100.0 ,
                                                 100.0, 100.0)
                
                if (board[col][row].index == -1)
                {
                    NSColor.black.setFill()
                    //[[NSColor blackColor] setFill];
                    NSRectFill(tileRect)
                    blankX = col;
                    blankY = row;
                    continue;
                }
                
                if (board[col][row].color == 1)
                {
                    //[[NSColor whiteColor] setFill];
                    NSColor.white.setFill()
                }
                else
                {
                    //[[NSColor redColor] setFill];
                    NSColor.red.setFill()
                }
                NSRectFill(tileRect);
                
                // select a font
                let font = NSFont(name: "Palatino-Roman", size:48.0)
                // center align
                let style = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
                style.alignment = NSTextAlignment.center
                // text with Gold Color
                // https://github.com/mbarriault/McChunk/blob/master/McChunk/NSColor%2BMoreColors.m
                //
                let textColor = NSColor.init(deviceRed: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
                
                // add a shadow
                //
                let shadow:NSShadow = NSShadow()
                
                shadow.shadowOffset = CGSize(width: -2,height: -2)
                shadow.shadowColor = NSColor.gray
                
                let textAttributes = [
                    NSFontAttributeName : font!,
                    NSBaselineOffsetAttributeName : 1.0,
                    NSShadowAttributeName: shadow,
                    NSForegroundColorAttributeName: textColor,
                    NSParagraphStyleAttributeName: style
                ] as [String : Any]
                
                let string = NSString(format: "%d",board[col][row].index )
                
                string.draw(in: tileRect, withAttributes:textAttributes)
                
            }
        }
    }
    
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        //
        NSLog("mouseDown");
        
        var loc = theEvent.locationInWindow
        loc = convert(loc, from: nil)
        //loc.x -= frame.origin.x
        //loc.y -= frame.origin.y
        
        let x = Int(loc.x / 100.0)
        let y = Int(loc.y / 100.0)
        
        if (scrambled == false)
        {
            NSBeep();
            return;
        }
        
        // board.append(Element(x: x, y: y2, radius: r, lineWidth: lw, color: color))
        
        self.doMoveXY(x, ypos: y)
        
        if self.totalPositioned() == 15
        {
            scrambled = false
            
            needsDisplay = true
            
            // http://stackoverflow.com/questions/29433487/create-an-nsalert-with-swift
            
            let a = NSAlert()
            a.messageText = "Congratulations!"
            a.informativeText = "Puzzle solved"
            a.addButton(withTitle: "OK")
            a.alertStyle = NSAlertStyle.warning
            
            a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse) -> Void in
                if modalResponse == NSAlertFirstButtonReturn {
                    NSLog("Puzzle solved")
                }
            })
            
        }
        else
        {
            //[self setNeedsDisplay:YES];
            needsDisplay = true
        }
        
        
        
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        super.mouseDragged(with: theEvent)
        //
        NSLog("mouseDragged");
        
        needsDisplay = true
        //setNeedsDisplayInRect(bounds)
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        
        NSLog("mouseUp");
        
        
        //needsDisplay = true
    }
    
    //- doMoveX:(int)xpos Y:(int)ypos
    func doMoveXY(_ xpos:Int, ypos:Int)
    {
        
        NSLog("doMoveXY");
        //
        if xpos==blankX && ypos==blankY
        {
            NSBeep();
        }
        else if(xpos==blankX)   // blanky by xpos selected
        {
            if(ypos==blankY+1)   // if it is down
            {
                // down
                board[xpos][ypos-1] = board[xpos][ypos];
                board[xpos][ypos].index = -1;
                blankY = ypos;
            }
            else if(ypos==blankY-1)
            {
                // up
                board[xpos][ypos+1] = board[xpos][ypos];
                board[xpos][ypos].index = -1;
                blankY = ypos;
            }
        }
        else if(ypos==blankY)
        {
            if(xpos==blankX+1)
            {
                // right of blank
                board[xpos-1][ypos] = board[xpos][ypos];
                board[xpos][ypos].index = -1;
                blankX = xpos;
            }
            else if(xpos==blankX-1)
            {
                // left of blank
                board[xpos+1][ypos] = board[xpos][ypos];
                board[xpos][ypos].index = -1;
                blankX = xpos;
            }
        }
        else
        {
            NSBeep();
        }
    }
    
    // - (int)totalPositioned
    func totalPositioned()-> Int
    {
        var count:Int = 0
        
        for x in 0..<4 {
            for y in 0..<4 {
                if board[x][y].index == (x+1)+4*y
                {
                    count += 1;
                }
                
            }
        }
        return count;
    }
    
    // - shuffle:(id)sender
    func shuffle()
    {
        
        // let array[]:Int
        var array: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,-1]
        var j:Int
        var t:Int
        
        //
        NSLog("scramble")
        
        //
        // http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
        //
        // Write down the numbers from 1 through N.
        // Pick a random number k between one and the number of unstruck numbers remaining (inclusive).
        // Counting from the low end, strike out the kth number not yet struck out, and write it down elsewhere.
        // Repeat from step 2 until all the numbers have been struck out.
        // The sequence of numbers written down in step 3 is now a random permutation of the original numbers.
        //
        
        for i in 0..<15 {
            array[i] = i+1
        }
        array[15] = -1
        
        
        //
        for i in (1...15).reversed()
            // for (i = 15; i > 0; i--)
        {
            //j:Int =  lrand48() % 16
            //j = random() % 16
            let random = Int(arc4random())
            j = random % 16
            t = array[j]
            array[j] = array[i]
            array[i] = t
        }
        
        //for(y=0; y<4; y++)
        for y in 0..<4 {
            //for(x=0; x<4; x++)
            for x in 0..<4 {
                let val:Int =  array[y*4+x]
                board[x][y].index = val;
                if ( ( val>4 && val<9 ) || ( val>12 && val<16 ) )
                {
                    board[x][y].color = val % 2;
                }
                else
                {
                    board[x][y].color = (1 + val) % 2;
                }
            }
            
        }
        
        scrambled = true
        needsDisplay = true
    }
    
    override var isFlipped:Bool {
        get {
            return true
        }
    }
}
