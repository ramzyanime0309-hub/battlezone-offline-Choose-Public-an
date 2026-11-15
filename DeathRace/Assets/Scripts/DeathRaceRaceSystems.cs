using UnityEngine; using UnityEngine.UI;
public class DeathRaceWaypointAI:MonoBehaviour {
 public Transform[] points;public float speed=28f,turnRate=3f;int target;DeathRaceCarController car;
 void Awake(){car=GetComponent<DeathRaceCarController>();}
 void FixedUpdate(){if(points==null||points.Length==0||!car)return;Transform p=points[target%points.Length];Vector3 d=p.position-transform.position;d.y=0;if(d.magnitude<12)target=(target+1)%points.Length;float a=Vector3.SignedAngle(transform.forward,d.normalized,Vector3.up);car.SetInput(1,Mathf.Clamp(a/45f,-1,1)*turnRate,0,false);}
}
public class DeathRaceHUD:MonoBehaviour {
 public DeathRaceCarController player;public Text speedText,lapText,countdownText;public Image nitroFill;float countdown=3;int lap=1;
 void Update(){if(!player)return;if(countdown>0){countdown-=Time.deltaTime;if(countdownText)countdownText.text=countdown>0?Mathf.CeilToInt(countdown).ToString():"GO!";}if(speedText)speedText.text=Mathf.RoundToInt(player.SpeedKph)+" KM/H";if(lapText)lapText.text="LAP "+lap+"/3";if(nitroFill)nitroFill.fillAmount=player.nitro/100f;}
 void OnGUI(){if(!player)return;int w=Screen.width,h=Screen.height;float z=Mathf.Min(w,h)*.16f; if(GUI.RepeatButton(new Rect(18,h-z-22,z,z),"◀"))player.SetInput(1,-1,0,false);if(GUI.RepeatButton(new Rect(28+z,h-z-22,z,z),"▶"))player.SetInput(1,1,0,false);if(GUI.RepeatButton(new Rect(w-z-22,h-z-22,z,z),"GAS"))player.SetInput(1,0,0,false);if(GUI.RepeatButton(new Rect(w-z-22,h-z*2-32,z,z),"NITRO"))player.SetInput(1,0,0,true);if(GUI.Button(new Rect(w-z*2-34,h-z-22,z,z),"BRAKE"))player.SetInput(0,0,1,false);if(Event.current.type==EventType.MouseUp)player.SetInput(0,0,0,false);}
}
public class DeathRaceTrack:MonoBehaviour{public Transform[] waypoints;public static DeathRaceTrack Active;void Awake(){Active=this;}}
