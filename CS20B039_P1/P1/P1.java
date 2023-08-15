import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P1 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();

         GJDepthFirst df = new GJDepthFirst();
         Object value = root.accept(df, null);
         df.passnumber = 2; 
         Object value2 =root.accept(df,null);

         if (df.error) System.out.println("Type error");
         else System.out.println("Program type checked successfully");

      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
