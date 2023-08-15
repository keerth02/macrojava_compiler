import syntaxtree.*;
import visitor.*;

public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new MiniRAParser(System.in).Goal();
         //System.out.println("Program parsed successfully");
         GJDepthFirst v = new GJDepthFirst();
         Object value = root.accept(v, null); // Your assignment part is invoked here.
         System.out.print(v.result);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 



