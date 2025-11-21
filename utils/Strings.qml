// Strings.qml
pragma Singleton
import Quickshell

Singleton {
    // Adds pad characters to the left of a string until it reaches the target length
    function leftPad(inputString, targetLength, padCharacter) {
        let result = inputString.toString();
        while (result.length < targetLength)result = padCharacter + result
        return result;
    }

    function rightCrop(inputString, targetLength, endingSequence = "...") {
        let result = inputString.toString();
        if (result.length <= targetLength)
            return result;

        const cropLength = targetLength - endingSequence.length;
        if (cropLength <= 0)
            return endingSequence;

        result = result.substring(0, cropLength) + endingSequence;
        return result;
    }

    // Tries to round a number to fit a specific target string length
    function roundToLength(value, targetLength) {
        if (value === null || isNaN(value))
            return null;

        let string = value.toString();
        if (string.length <= targetLength)
            return string;

        for (let decimals = 3; decimals >= 0; decimals--) {
            const temp = value.toFixed(decimals);
            if (temp.length <= targetLength)
                return temp;

        }
        return null;
    }

}
