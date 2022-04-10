const std = @import("std");
const pine = @import("lib.zig");

const lcd = pine.ST7789;
const font = pine.ZFont;

const Rect = struct {
    x: u8,
    y: u16,
    width: u8,
    height: u8,
};

const Cursor = struct {
    x: u8,
    y: u16,

    pub fn next(self: *Cursor) error{EndOfScreen}!void{
        if(self.x == 13){
            if(self.y == 9) return error.EndOfScreen;
            self.x = 0;
            self.down();
        } else {
            self.right();
        }
    }
    pub fn prev(self: *Cursor) error{StartOfScreen}!void{
        if(self.x == 0){
            if(self.y == 0) return error.StartOfScreen;
            self.x = 13;
            self.up();
        } else {
            self.left();
        }
    }

    pub fn rect(self: *Cursor) Rect {
        return .{
            .x = self.x * 17,
            .y = self.y * 25,
            .height = 17,
            .width = 25
        };
        }

    pub fn up(self: *Cursor) void{
        self.y -= 1;
    }

    pub fn down(self: *Cursor) void{
        self.y += 1;
    }

    pub fn left(self: *Cursor) void{
        self.x -= 1;
    }

    pub fn right(self: *Cursor) void{
        self.x += 1;
    }
};

var cursor: Cursor = .{
    .x = 0,
    .y = 0
};

pub fn writeToScreen(rect: Rect, char: []const u8) void {
     lcd.writeToScreen(rect.x, rect.y, rect.width, rect.height, char);
}

pub fn scrollDown() error{EndOfPhysicalScreen} !void {

}



pub fn writeChar(char: u8) !void {
    var img = font.getCharImage(char);
    const rect = cursor.rect();
    writeToScreen(rect, img);
    try cursor.next();

}

pub fn writeString(string: []const u8) !void {
    for(string) |char| {
        writeChar(char) catch {
            try scrollDown();
        };

    }
}


var screenIndex: u8 = 0; //index of character on the row
var screenXIndex: u8 = 0; //index where first pixel on x axis is
var screenYIndex: u16 = 0; //index where first pixel on y axis is

var scrollIndex: u16 = 0;

const screenXMax: u8 = 13; //max undex for character on a row


pub fn testOne() void{
    init();

    writeString("(HELLOWORLD)01") catch {
        
    };
}

pub fn init() void {

    screenIndex = 0;
    screenXIndex = 0;
    screenYIndex = 0;

    scrollIndex = 0;
    
    lcd.init();
}
pub fn draw(text: []const u8) void{
    for(text)|value|{
        //if screenbuffer > something scrolldown and write
        //addCharacter(value);
        //if writetoscreen will write past 320
        if(screenYIndex >= 294){
            var pixAtEnd: u16 = 320 - screenYIndex;
            var pixAtStart: u16 = 25 - pixAtEnd;
            var img = font.getCharImage(value);
            //pixAtEnd * (18 width of text img) * (2 bytes cause color is in 16bit)
            lcd.writeToScreen(screenXIndex, screenYIndex, screenXIndex + 17, 320, img[0..(pixAtEnd * 18 * 2)]);
            lcd.writeToScreen(screenXIndex, 0, screenXIndex + 17, pixAtStart, img[(pixAtEnd * 18 * 2)..]);
        }
        else{
            lcd.writeToScreen(screenXIndex, screenYIndex, screenXIndex + 17, screenYIndex + 25, font.getCharImage(value));
        }
        pine.Delay.delay(100 * pine.Delay.ms);
    if(screenIndex < screenXMax){
        screenXIndex += 17;
        screenIndex += 1;
    } else{
        screenXIndex = 0;
        screenYIndex += 25;
        screenIndex = 0;
        if(true){

            
            if(screenYIndex >= 320){
                screenYIndex -= 320;
            }

            scrollIndex += 25;
            if(scrollIndex >= 320){
                scrollIndex -= 320; 
            }

            scrollDown(scrollIndex);
            
            
        }


    }
    }

}

pub fn scrollDown2(pix: u16) void {
    const pixels = &[_]u8{ 0x00 } ** (50 * 240 * 2);
    //if scrolling over the end to beginning of the screenbuffer
    if(screenYIndex >= 275 and screenYIndex < 295){//268
        var pixAtEnd: u16 = 320 - screenYIndex - 25;
        var pixAtStart: u16 = 25 - pixAtEnd;
        
        //var txt: [1]u8 = undefined;
        //var si = decimal(screenYIndex);
        //txt[0] = numberToAscii(si.hundreds);    

        //lcd.writeToScreen(100, 100, 117, 125, font.getCharImage(txt[0]));
        
        lcd.writeToScreen(0, screenYIndex + 25, 240, 320, pixels[0..(pixAtEnd * 240 * 2)]); 
        lcd.writeToScreen(0, 0, 240, pixAtStart, pixels);     
    }
    else{
        lcd.writeToScreen(0, screenYIndex + 25, 240, screenYIndex + 50, pixels);
    }
    lcd.verticalScrollStartAddress(pix);
}
//number structs
const Decimal = struct{
    hundreds: u16,
    tens: u16,
    ones: u16
};

pub fn decimal(x: u16) Decimal {
    return .{
        .hundreds = x / 100,
        .tens = (x / 10) % 10,
        .ones = x % 10,
    };
}
pub fn numberToAscii(num: u16) u8 {
    switch(num){
    0 => return '0',
    1 => return '1',
    2 => return '2',
    3 => return '3',
    4 => return '4',
    5 => return '5',
    6 => return '6',
    7 => return '7',
    8 => return '8',
    9 => return '9',
    else => return 0,
    }

}