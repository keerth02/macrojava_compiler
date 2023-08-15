import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P2 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJDepthFirst df = new GJDepthFirst();
         df.passnumber=1;
         Object value = root.accept(df, null); // Your assignment part is invoked here.
         df.Map.Prep();
         df.Map.setMaxParameters();

         df.labelnumber = df.Map.labelno+10;
         df.curTemp = 2*df.Map.maxParams + 100;

         df.passnumber = 2;
         Object value2 = root.accept(df, null);

      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
