fun void playCombinations(string fileName, dur duration) {
    FileIO data;

    data.open(fileName, FileIO.READ);

    data => string init;
    data => int rows;
    data => int columns;
    <<< rows, columns >>>;

    string combinations[rows][columns];

    [[1243, 1345, 1711, 1808, 2357],
    [1238, 1335, 1701, 1798, 2352],
    [1168, 904, 855, 673, 624],
    [1162, 893, 845, 662, 613],
    [285, 220, 204, 161, 150]] @=> int freqs[][];

    for (int i; i < rows; i++) {
        for (int j; j < columns; j++) {
            data => combinations[i][j];
        }
    }

    SinOsc sin[columns];
    OscOut osc;

    osc.dest("127.0.0.1", 12001);

    for (int i; i < columns; i++) {
        sin[i].gain(0.2);
        sin[i] => env[i] => dac;
        env[i].set(0.1 * duration, 0.1 * duration, 1.0, 0.5 * duration);
    }

    for (int i; i < rows; i++) {
        for (int j; j < columns; j++) {
            combinations[i][j].charAt(0) - 49 => int player;
            combinations[i][j].charAt(1) - 65 => int pitch;
            sin[j].freq(freqs[player][pitch]);
            env[j].keyOn();
        }
        (duration * 0.1) => now;
        for (int j; j < columns; j++) {
            env[j].keyOff();
        }
        (duration * 0.9) => now;
    }

    for (int i; i < columns; i++) {
        sin[i] =< dac;
    }
}

5::second => dur duration;

playCombinations(me.dir() + "twos.txt", duration);
playCombinations(me.dir() + "threes.txt", duration);
playCombinations(me.dir() + "fours.txt", duration);
playCombinations(me.dir() + "fives.txt", duration);

/*
RED
1=2357Hz 5=1808Hz 4=1711Hz 3=1345Hz 2=1243Hz

BLUE
1=2352Hz 5=1798Hz 4=1701Hz 3=1335Hz 2=1238Hz

PINK
1=1168Hz 5=904Hz 4=855Hz 3=673 2=624Hz

GREEN
1=1162Hz 5=893Hz 4=845Hz 3=662Hz 2=613Hz

BLACK
1=285Hz 5=220Hz 4=204Hz 3=161Hz 2=150Hz
*/
