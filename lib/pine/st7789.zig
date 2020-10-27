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


