public class PrefixSuffixConversion {
    private String _prefix;
    private String _suffix;
    private int[] _matching_len;
    private int _ignoreRangeLow;
    private int _ignoreRangeHigh;

    private static boolean NO_MATCH = false;
    private static boolean MATCH = true;
    
    private static int MIN_PREFIX_FILLER_LENGTH = 9;
    private static int NO_PREFIX_FILLER_LENGTH = 0;
    private static int NO_RANGE_VALUE = 0;
    
    private static String EMPTY_STRING = "";
    private static String MATCHING_REGEX = "[^\\d.]";
    private static String PREFIX_FILLER = "{00";

    private String _prefixFiller = EMPTY_STRING;
    private int _minPrefixfillerLength = NO_PREFIX_FILLER_LENGTH;

    public PrefixSuffixConversion() {
        _prefix = EMPTY_STRING;
        _suffix = EMPTY_STRING;
        _matching_len = new int[NO_RANGE_VALUE];
        _ignoreRangeHigh = NO_RANGE_VALUE;
        _ignoreRangeLow = NO_RANGE_VALUE;
    }

    public PrefixSuffixConversion(String prefix, String suffix, int[] matching_lengths, int ignoreRangeLow, int ignoreRangeHigh) {
        _prefix = prefix;
        _suffix = suffix;
        _matching_len = matching_lengths;
        _ignoreRangeLow = ignoreRangeLow;
        _ignoreRangeHigh = ignoreRangeHigh;

        if (matching_lengths.length > NO_RANGE_VALUE) {
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

        return EMPTY_STRING;
    }

    public boolean isMatch(String value) {
        boolean goodLen = NO_MATCH;

        String temp = value.replaceAll(MATCHING_REGEX, EMPTY_STRING);

        if (Integer.parseInt(temp) >= getIngoreRangeLow() 
            && Integer.parseInt(temp) <= getIngoreRangeHigh()) {
            return NO_MATCH;
        }

        for (int i = 0; i < getMatchingLengths().length; i++) {
            if (getMatchingLengths()[i] == value.length()) {
                goodLen = MATCH;
                break;
            }
        }

        if (goodLen && value.startsWith(getPrefix())) {
                return MATCH;
        }

        return NO_MATCH;
    }

    public String toSSA(String value) {
        if (_minPrefixfillerLength <= NO_PREFIX_FILLER_LENGTH)
            return EMPTY_STRING;

        return getPrefixFiller(value) + value.replace(getPrefix(), EMPTY_STRING) + getSuffix();
    }
}
