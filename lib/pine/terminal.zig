const std = @import("std");
const pine = @import("lib.zig");

const lcd = pine.ST7789;
const font = pine.ZFont;

var textBuffer: [256]u8 = undefined;
var textBufferIndex: u8 = 0;
var textBufferStart: u8 = 0;
var textBufferEnd: u8 = 0;
var textBufferFull: bool = false;

//should index be on last or where the new character will be added?
pub fn addCharacter(character: u8) void {
    textBuffer[textBufferIndex] = character;
    if(textBufferIndex == 255){
        textBufferIndex = 0;
    }else{
        textBufferIndex += 1;
    }
    if(textBufferEnd == 255){
        textBufferEnd = 0;
    }else{
        textBufferEnd += 1;
    }
    if(textBufferEnd == textBufferStart){
        textBufferStart += 1;
    }
    if(textBufferStart > 255){
        textBufferStart = 0;
    }
    if(!textBufferFull){
        if(textBufferIndex >= 126){
            textBufferFull = true;
        }
    }
}
pub fn prevIndexOk() bool {
    if(textBufferIndex == textBufferStart){
        return false;
    }
    else{
        return true;
    }
}
pub fn moveToPrevIndex() void {
    if(prevIndexOk())
    {   
        textBufferIndex = textBufferIndex -% 1; 
        if(textBufferIndex == 0){
            textBufferIndex = 255;
        }else{
            textBufferIndex -= 1;
        }
        
    }
}
pub fn moveToChosenIndexOk(val: u8) bool{
    var newIndex: u8 = textBufferIndex -% val;
    if(newIndex >= textBufferStart and textBufferStart <= textBufferIndex){
        return true;
    }else {
        return false;
    }
}
pub fn moveToChosenIndex(val: u8) void{
    //if buffer is full the end will stop to exist andre
    var newIndex: u8 = textBufferIndex -% val;
    if(moveToChosenIndexOk(newIndex)){
        textBufferIndex = newIndex;
    }
}

var screenIndex: u8 = 0; //index of character on the row
var screenXIndex: u8 = 0; //index where first pixel on x axis is
var screenYIndex: u16 = 0; //index where first pixel on y axis is

var scrollIndex: u16 = 0;

const screenXMax: u8 = 13; //max undex for character on a row


pub fn testOne() void{
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXZ0123456789:()%";
    const str = "WHATWILLHAPPENNOW:FUTUREWILLTELL";
    init();

    //writing alot just to see if screen will scroll at the end.
    draw(characters);
    draw(characters);
    draw(characters);
    draw(str);
    draw(characters);
    draw(characters);
    draw(str);
    pine.Delay.delay(1000 * pine.Delay.ms);

    var txt: [1]u8 = undefined;
    draw("SI:");
    var si = decimal(screenIndex);
    txt[0] = numberToAscii(si.hundreds);
    draw(&txt);
    txt[0] = numberToAscii(si.tens);
    draw(&txt);
    txt[0] = numberToAscii(si.ones);
    draw(&txt);
    draw("TBI:");
    si = decimal(textBufferIndex);
    txt[0] = numberToAscii(si.hundreds);
    draw(&txt);
    txt[0] = numberToAscii(si.tens);
    draw(&txt);
    txt[0] = numberToAscii(si.ones);
    draw(&txt);

    //scrollUp(1);
    draw("TBI:");
    si = decimal(textBufferIndex);
    txt[0] = numberToAscii(si.hundreds);
    draw(&txt);
    txt[0] = numberToAscii(si.tens);
    draw(&txt);
    txt[0] = numberToAscii(si.ones);
    draw(&txt);

    draw("HELLO");
    
    
} 
pub fn init() void {
    textBufferIndex = 0;
    textBufferStart = 0;
    textBufferEnd = 0;
    textBufferFull = false;

    screenIndex = 0;
    screenXIndex = 0;
    screenYIndex = 0;

    scrollIndex = 0;
    
    lcd.init();
}
pub fn draw(text: []const u8) void{
    for(text)|value|{
        //if screenbuffer > something scrolldown and write
        addCharacter(value);
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
        if(textBufferFull){

            
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
pub fn scrollUp(rows: u16) void {
    //move back (screenIndex + thescreen) on textbufferindex
    var colARow: u8 = screenIndex + 14;
    var i: u8 = 0;
    while(true){
        if(i >= colARow) {break;}
        moveToPrevIndex();
        i += 1;
    }
    //write the the past row and then scroll up
    _ = rows;
    //const pixels = &[_]u8{ 0x00 } ** (26 * 240 * 2);
    //lcd.writeToScreen(0, screenYIndex +26, 240, screenYIndex + 51, pixels);
    //lcd.verticalScrollStartAddress(rows);
}
pub fn scrollDown(pix: u16) void {
    const pixels = &[_]u8{ 0x00 } ** (50 * 240 * 2);
    //if scrolling over the end to beginning of the screenbuffer
    if(screenYIndex >= 275 and screenYIndex < 295){//268
        var pixAtEnd: u16 = 320 - screenYIndex + 25;
        var pixAtStart: u16 = 25 - pixAtEnd;
        
        lcd.writeToScreen(0, screenYIndex + 25, 240, 320, pixels); 
        lcd.writeToScreen(0, 0, 240, pixAtStart, pixels);     
    }
    else{
        lcd.writeToScreen(0, screenYIndex + 25, 240, screenYIndex + 50, pixels);
    }
    lcd.verticalScrollStartAddress(pix);
}
pub fn scrollDownAndWrite() void {}
//number structs
const Decimal = struct{
    hundreds: u8,
    tens: u8,
    ones: u8
};

pub fn decimal(x: u8) Decimal {
    return .{
        .hundreds = x / 100,
        .tens = (x / 10) % 10,
        .ones = x % 10,
    };
}
pub fn numberToAscii(num: u8) u8 {
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