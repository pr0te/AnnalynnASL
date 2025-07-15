state("Annalynn") {
    int coinsLeft : "annalynn.exe", 0x8795C0, 0x90, 0x108, 0x78;
    int roomId : "annalynn.exe", 0x8799D0, 0xDC8;
    int igt : "annalynn.exe", 0xB28F90, 0x30, 0xBC0, 0x854;
    int bossSprite : "annalynn.exe", 0xB45928, 0x254;
}

init {
    vars.coinZeroCount = 0;
    vars.splitCooldown = false;
}

update {
    if (current.coinsLeft == 0) {
        vars.coinZeroCount++;
    }
    else {
        vars.coinZeroCount = 0;
    }

    if (current.roomId != old.roomId || current.roomId == 4 || current.roomId == 27) {
        vars.coinZeroCount = 0;
        vars.splitCooldown = false;
    }
}

start {
    return current.roomId == 10 && old.roomId == 6;
}

split {
    return (
        !vars.splitCooldown && (
            (current.roomId >= 10 && current.roomId <= 15) ||
            (current.roomId >= 18 && current.roomId <= 27)
        ) && (
            (current.coinsLeft == 0 && vars.coinZeroCount > 2 && current.roomId != 27) || 
            (current.roomId == 27 && current.bossSprite == 0 && old.bossSprite != 0)
        )
    );
}

isLoading {
    return current.roomId < 10 || (current.roomId > 15 && current.roomId < 18) || current.roomId > 27;
}

onSplit {
    vars.splitCooldown = true;
}

reset {
    return current.roomId == 4;
}

onReset {
    vars.splitCooldown = false;
}