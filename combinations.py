import itertools
import collections
import numpy as np
import matplotlib.pyplot as plt


def filterCombinations(combinations):
    filteredCombinations = []

    for combination in combinations:
        valid = False

        players = []
        for value in combination:
            players.append(value[0])

        counter = collections.Counter(players)

        for value in counter.values():
            if value < 3:
                valid = True

        if valid:
            filteredCombinations.append(combination)

    return filteredCombinations


def plotPlayers(combinations):
    data = []

    for combination in combinations:

        players = [0, 0, 0, 0, 0]
        for value in combination:
            players[int(value[0]) - 1] = 1

        data.append(players)

    data = np.array(data)

    plt.imshow(data.T, aspect='auto', cmap='viridis', origin='lower', interpolation='nearest')
    plt.show()


possibilities = ['1A', '1B', '1C', '1D', '1E',
                 '2A', '2B', '2C', '2D', '2E',
                 '3A', '3B', '3C', '3D', '3E',
                 '4A', '4B', '4C', '4D', '4E',
                 '5A', '5B', '5C', '5D', '5E']

# twos = filterCombinations(list(itertools.combinations(possibilities, 2)))
threes = filterCombinations(list(itertools.combinations(possibilities, 3)))
# fours = filterCombinations(list(itertools.combinations(possibilities, 4)))
# fives = filterCombinations(list(itertools.combinations(possibilities, 5)))

# combinations = np.array(twos)
# header = str(combinations.shape[0]) + " " + str(combinations.shape[1])
# np.savetxt("twos.txt", combinations, delimiter=" ", fmt="%s", header=header)

combinations = np.array(threes)
header = str(combinations.shape[0]) + " " + str(combinations.shape[1])
np.savetxt("threes.txt", combinations, delimiter=" ", fmt="%s", header=header)

# combinations = np.array(fours)
# header = str(combinations.shape[0]) + " " + str(combinations.shape[1])
# np.savetxt("fours.txt", combinations, delimiter=" ", fmt="%s", header=header)

# combinations = np.array(fives)
# header = str(combinations.shape[0]) + " " + str(combinations.shape[1])
# np.savetxt("fives.txt", combinations, delimiter=" ", fmt="%s", header=header)
