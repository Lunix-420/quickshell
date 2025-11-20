// CpuStats.qml
pragma Singleton
import Quickshell

Singleton {
    function leftPadString(inputString, targetLength, padCharacter) {
        let result = inputString.toString();
        while (result.length < targetLength)result = padCharacter + result
        return result;
    }

}
