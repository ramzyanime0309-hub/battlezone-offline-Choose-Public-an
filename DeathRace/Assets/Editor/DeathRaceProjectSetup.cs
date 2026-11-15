using UnityEditor;using UnityEditor.SceneManagement;using UnityEngine;using UnityEngine.UI;using UnityEngine.SceneManagement;
public static class DeathRaceProjectSetup{
 const string ScenePath="Assets/Scenes/DeathRacePrototype.unity";
 [MenuItem("Death Race/Generate Playable Prototype")]
 public static void EnsureProject(){
  if(!AssetDatabase.IsValidFolder("Assets/Scenes"))AssetDatabase.CreateFolder("Assets","Scenes");
  Scene scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single);
  Primitive(PrimitiveType.Cube,"Track Base",new Vector3(0,-.6f,0),new Vector3(190,1,190),new Color(.12f,.14f,.16f));
  Primitive(PrimitiveType.Cube,"Circuit Road",new Vector3(0,.02f,0),new Vector3(90,.2f,22),new Color(.22f,.23f,.25f));
  Primitive(PrimitiveType.Cube,"Runoff",new Vector3(0,-.1f,18),new Vector3(110,.5f,10),new Color(.1f,.35f,.15f));
  var route=new GameObject("AI Route").AddComponent<DeathRaceTrack>();route.waypoints=new Transform[4];Vector3[] pos={new Vector3(-38,0,-7),new Vector3(38,0,-7),new Vector3(38,0,7),new Vector3(-38,0,7)};
  for(int i=0;i<4;i++){var p=new GameObject("Waypoint "+i).transform;p.position=pos[i];p.SetParent(route.transform);route.waypoints[i]=p;}
  var player=Car("Player Car",new Vector3(-25,1,-3),new Color(.8f,.04f,.03f),true);
  for(int i=0;i<3;i++){var rival=Car("Rival "+(i+1),new Vector3(-35+i*7,1,4),new Color(.05f,.25f,.85f),false);rival.AddComponent<DeathRaceWaypointAI>().points=route.waypoints;}
  var camObject=new GameObject("Chase Camera",typeof(Camera),typeof(AudioListener));camObject.GetComponent<Camera>().fieldOfView=65;var camera=camObject.AddComponent<DeathRaceChaseCamera>();camera.target=player.transform;
  var hud=new GameObject("Race HUD").AddComponent<DeathRaceHUD>();hud.player=player.GetComponent<DeathRaceCarController>();
  var canvas=new GameObject("HUD Canvas",typeof(Canvas),typeof(CanvasScaler),typeof(GraphicRaycaster));canvas.GetComponent<Canvas>().renderMode=RenderMode.ScreenSpaceOverlay;
  hud.speedText=Text(canvas.transform,"Speed",new Vector2(.82f,.9f),30);hud.lapText=Text(canvas.transform,"Lap",new Vector2(.15f,.9f),24);hud.countdownText=Text(canvas.transform,"Countdown",new Vector2(.5f,.82f),46);
  var fg=new GameObject("Nitro",typeof(RectTransform),typeof(CanvasRenderer),typeof(Image));fg.transform.SetParent(canvas.transform,false);var r=fg.GetComponent<RectTransform>();r.anchorMin=new Vector2(.72f,.08f);r.anchorMax=new Vector2(.96f,.12f);r.offsetMin=r.offsetMax=Vector2.zero;hud.nitroFill=fg.GetComponent<Image>();hud.nitroFill.type=Image.Type.Filled;
  RenderSettings.ambientLight=Color.gray;var sun=new GameObject("Sun").AddComponent<Light>();sun.type=LightType.Directional;sun.transform.rotation=Quaternion.Euler(50,-30,0);
  EditorBuildSettings.scenes=new[]{new EditorBuildSettingsScene(ScenePath,true)};PlayerSettings.productName="Death Race";PlayerSettings.companyName="Independent Studio";PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android,"com.independent.deathrace");PlayerSettings.defaultInterfaceOrientation=UIOrientation.LandscapeLeft;
  EditorSceneManager.SaveScene(scene,ScenePath);AssetDatabase.SaveAssets();AssetDatabase.Refresh();Debug.Log("Death Race demo scene generated.");
 }
 static void Primitive(PrimitiveType t,string n,Vector3 p,Vector3 s,Color c){var o=GameObject.CreatePrimitive(t);o.name=n;o.transform.position=p;o.transform.localScale=s;o.GetComponent<Renderer>().sharedMaterial=Material(c);}
 static GameObject Car(string n,Vector3 p,Color c,bool player){var root=new GameObject(n);root.transform.position=p;root.tag=player?"Player":"Untagged";var body=GameObject.CreatePrimitive(PrimitiveType.Cube);body.transform.SetParent(root.transform);body.transform.localPosition=new Vector3(0,.45f,0);body.transform.localScale=new Vector3(2,.65f,4.1f);body.GetComponent<Renderer>().sharedMaterial=Material(c);var rb=root.AddComponent<Rigidbody>();rb.mass=1150;rb.interpolation=RigidbodyInterpolation.Interpolate;root.AddComponent<DeathRaceCarController>();foreach(int x in new[]{-1,1})foreach(int z in new[]{-1,1}){var w=GameObject.CreatePrimitive(PrimitiveType.Cylinder);w.transform.SetParent(root.transform);w.transform.localScale=new Vector3(.42f,.18f,.42f);w.transform.localRotation=Quaternion.Euler(90,0,0);w.transform.localPosition=new Vector3(x*1.05f,.18f,z*1.25f);w.GetComponent<Renderer>().sharedMaterial=Material(Color.black);}return root;}
 static Material Material(Color c){var m=new Material(Shader.Find("Standard"));m.color=c;return m;}
 static Text Text(Transform p,string n,Vector2 a,int size){var o=new GameObject(n,typeof(RectTransform),typeof(CanvasRenderer),typeof(UnityEngine.UI.Text));o.transform.SetParent(p,false);var t=o.GetComponent<UnityEngine.UI.Text>();t.font=Resources.GetBuiltinResource<Font>("Arial.ttf");t.fontSize=size;t.color=Color.white;t.alignment=TextAnchor.MiddleCenter;var r=o.GetComponent<RectTransform>();r.anchorMin=r.anchorMax=a;r.sizeDelta=new Vector2(260,70);return t;}
}
public class DeathRaceChaseCamera:MonoBehaviour{public Transform target;void LateUpdate(){if(!target)return;Vector3 d=target.position-target.forward*8+Vector3.up*4;transform.position=Vector3.Lerp(transform.position,d,Time.deltaTime*5);transform.LookAt(target.position+Vector3.up*1.2f);}}
