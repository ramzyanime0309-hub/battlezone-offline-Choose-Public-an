using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
public static class BattleZoneProjectSetup{
 const string ScenePath="Assets/Scenes/BattleZonePrototype.unity";
 [MenuItem("BattleZone/Generate Playable Prototype")]
 public static void EnsureProject(){
 Directory.CreateDirectory("Assets/Scenes");
 var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single);
 GameObject floor=GameObject.CreatePrimitive(PrimitiveType.Plane);floor.name="Arena Ground";floor.transform.localScale=new Vector3(5,1,5);Colorize(floor,new Color(.24f,.31f,.22f));
 Wall("North Cover",new Vector3(0,1,18),new Vector3(22,2,1));Wall("South Cover",new Vector3(0,1,-18),new Vector3(22,2,1));Wall("East Cover",new Vector3(22,1,0),new Vector3(1,2,36));Wall("West Cover",new Vector3(-22,1,0),new Vector3(1,2,36));Wall("Central Cover",new Vector3(-7,.8f,2),new Vector3(5,1.6f,1.2f));
 GameObject player=GameObject.CreatePrimitive(PrimitiveType.Capsule);player.name="Player";player.transform.position=new Vector3(0,1,-10);player.GetComponent<Renderer>().enabled=false;Object.DestroyImmediate(player.GetComponent<CapsuleCollider>());CharacterController cc=player.AddComponent<CharacterController>();cc.height=2;cc.radius=.45f;PrototypePlayer pc=player.AddComponent<PrototypePlayer>();
 GameObject camObj=new GameObject("Player Camera");camObj.transform.SetParent(player.transform);camObj.transform.localPosition=new Vector3(0,.62f,0);Camera cam=camObj.AddComponent<Camera>();cam.fieldOfView=78;camObj.AddComponent<AudioListener>();pc.cameraPivot=camObj.transform;pc.playerCamera=cam;
 PrototypeMatch match=new GameObject("Match Manager").AddComponent<PrototypeMatch>();int count=6;
 for(int i=0;i<count;i++){float a=i*Mathf.PI*2/count;GameObject bot=GameObject.CreatePrimitive(PrimitiveType.Capsule);bot.name="Enemy Bot "+(i+1);bot.transform.position=new Vector3(Mathf.Cos(a)*13,1,Mathf.Sin(a)*13);Colorize(bot,new Color(.65f,.16f,.12f));PrototypeBot ai=bot.AddComponent<PrototypeBot>();ai.target=player.transform;}match.RegisterBots(count);
 GameObject lightObj=new GameObject("Sun");Light sun=lightObj.AddComponent<Light>();sun.type=LightType.Directional;sun.intensity=1.15f;lightObj.transform.rotation=Quaternion.Euler(50,-30,0);RenderSettings.ambientLight=new Color(.55f,.55f,.55f);new GameObject("Mobile HUD").AddComponent<PrototypeHUD>();
 EditorSceneManager.SaveScene(scene,ScenePath);EditorBuildSettings.scenes=new[]{new EditorBuildSettingsScene(ScenePath,true)};
 PlayerSettings.productName="BattleZone Offline";PlayerSettings.companyName="BattleZone Studio";PlayerSettings.applicationIdentifier="com.battlezone.offline";PlayerSettings.bundleVersion="0.1.0";PlayerSettings.Android.bundleVersionCode=1;PlayerSettings.defaultInterfaceOrientation=UIOrientation.LandscapeLeft;PlayerSettings.SetScriptingBackend(UnityEditor.Build.NamedBuildTarget.Android,ScriptingImplementation.IL2CPP);PlayerSettings.Android.minSdkVersion=AndroidSdkVersions.AndroidApiLevel23;AssetDatabase.SaveAssets();Debug.Log("BattleZone scene generated with six offline bots.");
 }
 static void Wall(string n,Vector3 p,Vector3 s){GameObject o=GameObject.CreatePrimitive(PrimitiveType.Cube);o.name=n;o.transform.position=p;o.transform.localScale=s;Colorize(o,new Color(.34f,.37f,.4f));}
 static void Colorize(GameObject o,Color c){Renderer r=o.GetComponent<Renderer>();Shader sh=Shader.Find("Universal Render Pipeline/Lit");if(sh==null)sh=Shader.Find("Standard");if(sh!=null)r.sharedMaterial=new Material(sh){color=c};}
}