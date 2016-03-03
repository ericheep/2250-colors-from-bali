// 2250-colors-from-bali.ck
// Eric Heep & Sara Cubarsi

OscOut out;

out.dest("127.0.0.1", 12001);

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
    ADSR env[columns];
    string currentPitches[5][2];
    string upcomingPitches[5][2];

    int upcomingPlayer, currentPlayer;
    int upcomingPitch, currentPitch;

    for (int i; i < columns; i++) {
        sin[i].gain(0.2);
        sin[i] => env[i] => dac;
        env[i].set(0.01 * duration, 0::samp, 1.0, 0.99 * duration);
    }

    shuffledArray(rows) @=> int shuffle[];


    for (int i; i < rows; i++) {
        // frames per second for an envelope
        out.start("/fadeData");
        out.add((duration/second * 60)$int);
        out.add(i % 2);
        out.send();

        for (int j; j < 5; j++) {
            for (int k; k < 2; k++) {
                upcomingPitches[j][k] => currentPitches[j][k];
                "_" => upcomingPitches[j][k];
            }
        }

        for (int j; j < columns; j++) {
            combinations[shuffle[i]][j].charAt(0) - 49 => upcomingPlayer;
            combinations[shuffle[i]][j].charAt(1) - 65 => upcomingPitch;

            if (i != 0) {
                sin[j].freq(freqs[currentPlayer][currentPitch]);
                env[j].keyOn();
            }

            upcomingPlayer => currentPlayer;
            upcomingPitch => currentPitch;

            if (upcomingPitches[upcomingPlayer][0] == "_") {
                (upcomingPitch + 1) + "" => upcomingPitches[upcomingPlayer][0];
            }
            else {
                (upcomingPitch + 1) + "" => upcomingPitches[upcomingPlayer][1];
            }
        }

        <<< currentPitches[0][0], currentPitches[0][1] + " ",
            currentPitches[1][0], currentPitches[1][1] + " ",
            currentPitches[2][0], currentPitches[2][1] + " ",
            currentPitches[3][0], currentPitches[3][1] + " ",
            currentPitches[4][0], currentPitches[4][1] >>>;

        oscArrayOut("/upcomingPitches", upcomingPitches);

        spork ~ metronome(duration, 8);

        (duration * 0.01) => now;
        for (int j; j < columns; j++) {
            env[j].keyOff();
        }
        (duration * 0.99) => now;
    }

    for (int i; i < columns; i++) {
        sin[i] =< dac;
    }
}

fun void metronome(dur duration, int subdivisions) {
    duration/subdivisions => dur subDur;
    for (0 => int i; i < subdivisions; i++) {
        out.start("/metronome");
        out.add(i);
        out.send();
        subDur => now;
    }
}

fun void oscArrayOut(string addr, string data[][]) {
    out.start(addr);
    for (int i; i < 5; i++) {
        for (int j; j < 2; j++) {
            out.add(data[i][j]);
        }
    }
    out.send();
}

fun int[] shuffledArray(int size) {
    int arr[size];

    for (0 => int i; i < size; i++) {
        i => arr[i];
    }

    for (size - 1 => int i; i > 0; i--) {
        Math.random2(0, size - 1) => int j;

        int temp, a, b;

        arr[i] => temp;
        arr[j] => arr[i];
        temp => arr[j];

    }

    return arr;
}

shuffledArray(8);

// time for exactly 3 hours
4.8::second => dur duration;

10::second => now;
// playCombinations(me.dir() + "twos.txt", duration);
playCombinations(me.dir() + "threes.txt", duration);
// playCombinations(me.dir() + "fours.txt", duration);
// playCombinations(me.dir() + "fives.txt", duration);

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
