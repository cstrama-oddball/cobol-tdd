public class rrbtossa{

    private PrefixSuffixConversion[] prefix_array;

    public rrbtossa() {
        loadPrefixArray();
    }

    public String[] process(String rrbs[]){

        String[] converted = new String[rrbs.length];

        for (int x = 0; x < rrbs.length; x++) {

            PrefixSuffixConversion result = findPrefixSuffix(rrbs[x].toUpperCase());

            converted[x] = result.toSSA(rrbs[x].toUpperCase());
        }

        return converted;
    }

    private void loadPrefixArray() {
        prefix_array = new PrefixSuffixConversion[15];

        // reverse the order of the list to have the longest prefixes checked first, in case a shorter
        // prefix has the same start letters
        prefix_array[14] = new PrefixSuffixConversion("A",   "10", new int[] {7, 10}, 991274, 994999);
        prefix_array[13] = new PrefixSuffixConversion("H",   "80", new int[] {7, 10},  49160, 994999);
        prefix_array[12] = new PrefixSuffixConversion("MA",  "14", new int[] {8, 11}, 991274, 994999);
        prefix_array[11] = new PrefixSuffixConversion("PA",  "15", new int[] {8, 11}, 991274, 994999);
        prefix_array[10] = new PrefixSuffixConversion("WA",  "16", new int[] {8, 11}, 991274, 994999);
        prefix_array[9]  = new PrefixSuffixConversion("CA",  "17", new int[] {8, 11}, 991274, 994999);
        prefix_array[8]  = new PrefixSuffixConversion("PD",  "45", new int[] {8, 11}, 415936, 994999);
        prefix_array[7]  = new PrefixSuffixConversion("WD",  "46", new int[] {8, 11}, 415936, 994999);
        prefix_array[6]  = new PrefixSuffixConversion("JA",  "11", new int[] {8, 11}, 991274, 994999);
        prefix_array[5]  = new PrefixSuffixConversion("MH",  "84", new int[] {8, 11},  49160, 994999);
        prefix_array[4]  = new PrefixSuffixConversion("PH",  "85", new int[] {8, 11},  49160, 994999);
        prefix_array[3]  = new PrefixSuffixConversion("WH",  "86", new int[] {8, 11},  49160, 994999);
        prefix_array[2]  = new PrefixSuffixConversion("WCA", "13", new int[] {9, 12}, 991274, 994999);
        prefix_array[1]  = new PrefixSuffixConversion("WCD", "43", new int[] {9, 12}, 415936, 994999);
        prefix_array[0]  = new PrefixSuffixConversion("WCH", "83", new int[] {9},      49160, 994999);
    }

    private PrefixSuffixConversion findPrefixSuffix(String value) {
        for (int x = 0; x < prefix_array.length; x++) {
            if (prefix_array[x].isMatch(value)) {
                return prefix_array[x];
            }
        }

        // return default object that has no match
        return new PrefixSuffixConversion();
    }
}