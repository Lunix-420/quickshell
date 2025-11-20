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

    function normalize(value) {
        const units = ["B", "kB", "MB", "GB", "TB"];
        let unitIndex = 0;
        let speed = value;
        while (speed >= 1000 && unitIndex < units.length - 1) {
            speed /= 1024;
            unitIndex++;
        }
        const unit = units[unitIndex];
        return [speed, unit];
    }

}
