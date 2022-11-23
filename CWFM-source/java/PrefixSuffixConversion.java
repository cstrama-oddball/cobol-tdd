public class PrefixSuffixConversion {
    private String _prefix;
    private String _suffix;
    private int[] _matching_len;
    private int _ignoreRangeLow;
    private int _ignoreRangeHigh;

    private static String PREFIX_FILLER = "{00";
    private static int MIN_PREFIX_FILLER_LENGTH = 9;

    private String _prefixFiller = "";
    private int _minPrefixfillerLength = 0;

    public PrefixSuffixConversion(String prefix, String suffix, int[] matching_lengths, int ignoreRangeLow, int ignoreRangeHigh) {
        _prefix = prefix;
        _suffix = suffix;
        _matching_len = matching_lengths;
        _ignoreRangeLow = ignoreRangeLow;
        _ignoreRangeHigh = ignoreRangeHigh;

        if (matching_lengths.length > 0) {
            _prefixFiller = PREFIX_FILLER;
            _minPrefixfillerLength = MIN_PREFIX_FILLER_LENGTH;    
        }
    }

    public String getPrefix() {
        return _prefix;
    }

    public String getSuffix() {
        return _suffix;
    }

    public int[] getMatchingLengths() {
        return _matching_len;
    }

    public int getIngoreRangeLow() {
        return _ignoreRangeLow;
    }

    public int getIngoreRangeHigh() {
        return _ignoreRangeHigh;
    }

    public String getPrefixFiller(String value) {
        if (value.length() <= _minPrefixfillerLength)
            return _prefixFiller;

        return "";
    }

    public boolean isMatch(String value) {
        boolean goodLen = false;

        String temp = value.replaceAll("[^\\d.]", "");

        if (Integer.parseInt(temp) >= getIngoreRangeLow() && Integer.parseInt(temp) <= getIngoreRangeHigh()) {
            return false;
        }

        for (int i = 0; i < getMatchingLengths().length; i++) {
            if (getMatchingLengths()[i] == value.length()) {
                goodLen = true;
                break;
            }
        }

        if (goodLen) {
            if (value.startsWith(getPrefix()))
                return true;
        }

        return false;
    }

    public String toSSA(String value) {
        if (_minPrefixfillerLength <= 0)
            return "";

        return getPrefixFiller(value) + value.replace(getPrefix(), "") + getSuffix();
    }
}
