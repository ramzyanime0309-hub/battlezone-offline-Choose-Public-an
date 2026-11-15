using System;
[Serializable] public class DeathRaceCarEntry{public string manufacturer,model,className;public int unlockLevel;public bool requested;}
public static class DeathRaceCarCatalog{
 public static readonly DeathRaceCarEntry[] Cars={
 C("Lamborghini","Veneno","Hypercar",1,true),C("Lamborghini","Egoista","Hypercar",8,true),C("Lamborghini","Terzo Millennio","Electric",12,true),
 C("Apollo","Intensa Emozione","Hypercar",15,true),C("Apollo","Evo","Hypercar",18,true),C("Apollo","Arrow","Hypercar",22,true),C("Apollo","Project EVO","Hypercar",25,true),
 C("Lamborghini","Sián FKP 37","Hypercar",10,false),C("Lamborghini","Aventador SVJ","Hypercar",6,false),C("Lamborghini","Huracán STO","Supercar",4,false),C("Lamborghini","Countach LPI 800-4","Supercar",14,false),C("Lamborghini","Revuelto","Hypercar",20,false),C("Lamborghini","Essenza SCV12","Track",24,false),C("Lamborghini","Centenario","Hypercar",16,false)};
 static DeathRaceCarEntry C(string a,string b,string c,int d,bool e)=>new DeathRaceCarEntry{manufacturer=a,model=b,className=c,unlockLevel=d,requested=e};
}
