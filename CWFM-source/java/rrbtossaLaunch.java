public class rrbtossaLaunch {
    public static void main(String args[]){
        String[] rrb = args[0].split(",");

        rrbtossa convert = new rrbtossa();

        String[] converted = convert.process(rrb);

        for (int x = 0; x < rrb.length; x++) {
            System.out.println(rrb[x] + " converted to " + converted[x]);
        }
    }
}
