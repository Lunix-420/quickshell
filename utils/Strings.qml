// CpuStats.qml
pragma Singleton
import Quickshell

Singleton {
    function leftPad(inputString, targetLength, padCharacter) {
        let result = inputString.toString();
        while (result.length < targetLength)result = padCharacter + result
        return result;
    }

}
