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

}
