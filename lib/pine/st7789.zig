const pine = @import("lib.zig");
pub const Color = packed struct { red: u5, green: u6, blue: u5 };

pub const Command = enum(u8) {
    swreset = 0x01,
    slpout = 0x11,
    noron = 0x13,
    invon = 0x21,
    dispon = 0x29,
    caset = 0x2a,
    raset = 0x2b,
    ramwr = 0x2c,
    vscrdef = 0x33,
    colmod = 0x3a,
    madctl = 0x36,
    vscsad = 0x37,
};

const spiMaster = pine.SpiMaster{
    .spim = pine.Spim.spim0,
    .ssPin = pine.GpioPin.tp_int,
};

const screenSizeX: u16 = 240;
const screenSezeY: u16 = 240;

const resetPin = pine.GpioPin.hrs3300_test; //30
const dcPin = pine.GpioPin.ain5; //29

pub fn init() void {
    resetPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });
    dcPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    spiMaster.init(.{ .pin = 4 }, .{ .pin = 3 }, pine.Spim.Frequency.m8, .{ .order = true, .cpha = true, .cpol = true });

    pine.Delay.delay(50 * pine.Delay.ms);

    hwReset();

    //send init commands to lcd

    swReset();
    sleepOut();
    colorMode(.{ .ctrlColFormat = ._16bit, .rgbColFormat = ._65k });
    memoryDataAccessControl(.{});

    columnAddressSet(0, 240);
    rowAddressSet(0, 240);
    displayInversionOn();
    normalModeOn();
    displayOn();
}

pub fn setDataPin() void {
    pine.Gpio.set(.{ .ain5 = true });
}

pub fn setCommandPin() void {
    pine.Gpio.clear(.{ .ain5 = true });
}

pub fn hwReset() void {
    pine.Gpio.clear(.{ .hrs3300_test = true });
    pine.Delay.delay(15 * pine.Delay.ms);

    pine.Gpio.set(.{ .ain5 = true });
    pine.Delay.delay(2 * pine.Delay.ms);
}

//Will have to wait 5ms before sending any new command or 120ms before sending
//sleep out command.
pub fn swReset() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.swreset));
    pine.Delay.delay(150 * pine.Delay.ms);
}

// will have to wait 5 ms before sending new command or 120ms before sending
// sleep in command.
pub fn sleepOut() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.slpout));
    pine.Delay.delay(10 * pine.Delay.ms);
}

pub const RGBColorFormat = enum(u3) {
    _65k = 5,
    _262k = 6,
};

pub const ControlColorFormat = enum(u3) {
    _12bit = 3,
    _16bit = 5,
    _18bit = 6,
    _16mtrunc = 7,
};

pub const ColorMode = packed struct {
    ctrlColFormat: ControlColorFormat = 0,

    _unused1: u1 = 0,

    rgbColFormat: RGBColorFormat = 0,

    _unused2: u1 = 0,
};

pub fn colorMode(cd: ColorMode) void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.colmod));
    setDataPin();
    spiMaster.write(@bitCast(u8, cd));

    pine.Delay.delay(10 * pine.Delay.ms);
}

///Bit D7- Page Address Order “0” = Top to Bottom (When MADCTL D7=”0”). “1” = Bottom to Top (When MADCTL D7=”1”).
///Bit D6- Column Address Order “0” = Left to Right (When MADCTL D6=”0”). “1” = Right to Left (When MADCTL D6=”1”).
///Bit D5- Page/Column Order “0” = Normal Mode (When MADCTL D5=”0”). “1” = Reverse Mode (When MADCTL D5=”1”) Note: Bits D7 to D5, alse refer to section 8.12 Address Control
///Bit D4- Line Address Order “0” = LCD Refresh Top to Bottom (When MADCTL D4=”0”) “1” = LCD Refresh Bottom to Top (When MADCTL D4=”1”)
///Bit D3- RGB/BGR Order “0” = RGB (When MADCTL D3=”0”) “1” = BGR (When MADCTL D3=”1”) "colorOrder"
///Bit D2- Display Data Latch Data Order “0” = LCD Refresh Left to Right (When MADCTL D2=”0”) “1” = LCD Refresh Right to Left (When MADCTL D2=”1”)
pub const MemoryDataAccessConfig = packed struct {
    _unused1: u2 = 0,

    displayDataLatchDataOrder: bool = false,
    colorOrder: bool = false,
    lineAddressOrder: bool = false,
    pageColumnOrder: bool = false,
    colAddressOrder: bool = false,
    pageAddressOrder: bool = false,
};

pub fn memoryDataAccessControl(cfg: MemoryDataAccessConfig) void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.madctl));
    setDataPin();
    spiMaster.write(@bitCast(u8, cfg));
}

pub fn columnAddressSet(start: u16, width: u16) void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.caset));
    setDataPin();

    var casetData = [_]u8{
        (@intCast(u8, start >> 8)),
        (@intCast(u8, start % 0xFF)),
        (@intCast(u8, width >> 8)),
        (@intCast(u8, width % 0xFF)),
    };

    spiMaster.writeBytes(casetData[0..]);
}
pub fn rowAddressSet(start: u16, height: u16) void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.raset));
    setDataPin();

    var rasetData = [_]u8{
        (@intCast(u8, start >> 8)),
        (@intCast(u8, start % 0xFF)),
        (@intCast(u8, height >> 8)),
        (@intCast(u8, height % 0xFF)),
    };

    spiMaster.writeBytes(rasetData[0..]);
}

pub fn ramWrite() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.ramwr));
    setDataPin();
}
pub fn setAddressWindow(startX: u16, startY: u16, width: u16, height: u16) void {
    columnAddressSet(startX, width);
    rowAddressSet(startY, height);
    ramWrite();
}

pub fn displayInversionOn() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.invon));
}

pub fn displayOn() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.dispon));
}

pub fn normalModeOn() void {
    setCommandPin();
    spiMaster.write(@enumToInt(Command.noron));
}
test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
