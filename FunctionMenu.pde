ListMenu createFunctionListMenu(Demo demo, ComplexFunction[] functions, int txtSize){
  String[] names = new String[functions.length];
  for(int i=0; i<functions.length; i++){    names[i] = functions[i].menuName();  }
  return createIntegerListMenu(demo,names,txtSize);
}

ListMenu createIntegerListMenu(Demo demo,int len, int txtSize){
  String[] names = new String[len];
  for(int i=0;i<len;i++){
    names[i] = Integer.toString(i);
  }
  return createIntegerListMenu(demo,names,txtSize);  
}
ListMenu createIntegerListMenu(Demo demo,String[] names, int txtSize){
  //factory method for ListMenu, creates a list of items 
  ListItem[] items = new ListItem[names.length];
  
  final PVector increment = new PVector(0,1.2*txtSize);//how far it has to move per listItem
  PVector cursor = new PVector(width/2,height/2f - increment.y*items.length/2f);//the position of the first listItem, used to track position
  final float colrate = TAU/items.length;//huechange per item
  
  int maxwidth = 0; //find the maximum label length
  for(int i=0; i<names.length;i++){maxwidth = max(maxwidth,names[i].length());}
  PVector size = new PVector(maxwidth*txtSize,increment.y); //use maxwidth to set size of buttons, full sides of a rectangle
  
  
  //generate listitems
  for(int i=0; i<names.length;i++){
    items[i] = new IntegerListItem(demo,i,names[i],cursor,size,i*colrate,0.7,0.7);
    cursor = cursor.add(increment);
  }
    
  return new ListMenu(items,txtSize);
}

class IntegerListItem extends ListItem{
    int val;
    Demo demo;
    IntegerListItem(Demo _demo,int _val,String name,PVector p,PVector s,float H, float S, float L){
      super(name,p,s,H,S,L);
      val = _val;
      demo = _demo;
    }
    
    void onSelect(){
      demo.menuAction(val);
    }
    
    Object value(){return val;}
    
}
