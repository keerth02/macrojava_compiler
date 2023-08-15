import syntaxtree.*;
import visitor.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         //System.out.println("Program parsed successfully");
         GJDepthFirst a = new GJDepthFirst();
         a.passnumber=1;
         Object value = root.accept(a, null); 
         a.Map.Initialize();
         //a.Map.PrintTable();
         a.passnumber=2;
         Object value2 = root.accept(a, null); 

      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 



