// Bytes.qml
pragma Singleton
import Quickshell

Singleton {
    function toKibiBytes(bytes) {
        return bytes / 1024;
    }

    function toMebiBytes(bytes) {
        return bytes / (1024 ** 2);
    }

    function toGibiBytes(bytes) {
        return bytes / (1024 ** 3);
    }

    function fromKibiBytes(kibibytes) {
        return kibibytes * 1024;
    }

    function fromMebiBytes(mebibytes) {
        return mebibytes * (1024 ** 2);
    }

    function fromGibiBytes(gibibytes) {
        return gibibytes * (1024 ** 3);
    }

    function normalize(value, minUnit = "B", threshold = 1000) {
        const units = ["B", "kB", "MB", "GB", "TB"];
        // Find the starting index based on minUnit
        const minUnitIndex = units.indexOf(minUnit);
        if (minUnitIndex === -1)
            throw new Error("Invalid minUnit: " + minUnit);

        let unitIndex = 0;
        let speed = value;
        // First pass, reach minUnit
        while (unitIndex < minUnitIndex) {
            speed /= 1024;
            unitIndex++;
        }
        // Second pass, reach appropriate unit
        while (speed >= threshold && unitIndex < units.length - 1) {
            speed /= 1024;
            unitIndex++;
        }
        const unit = units[unitIndex];
        return [speed, unit];
    }

}
