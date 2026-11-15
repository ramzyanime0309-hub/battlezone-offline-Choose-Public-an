using UnityEngine;
[RequireComponent(typeof(Rigidbody))]
public class DeathRaceCarController : MonoBehaviour {
 public float acceleration=32f,reverseAcceleration=12f,maxSpeed=52f,steering=105f,brakeStrength=7f,nitroForce=48f,nitro=100f,nitroDrain=34f,nitroRecharge=8f;
 Rigidbody body; float throttle,steer,brake; bool boost;
 public float SpeedKph=>body?body.velocity.magnitude*3.6f:0;
 void Awake(){body=GetComponent<Rigidbody>();body.mass=1150;body.drag=.08f;body.angularDrag=2.8f;body.centerOfMass=new Vector3(0,-.45f,0);}
 public void SetInput(float gas,float turn,float stop,bool useBoost){throttle=Mathf.Clamp(gas,-1,1);steer=Mathf.Clamp(turn,-1,1);brake=Mathf.Clamp01(stop);boost=useBoost;}
 void Update(){if(!CompareTag("Player"))return;float g=Input.GetAxisRaw("Vertical"),s=Input.GetAxisRaw("Horizontal");bool n=Input.GetKey(KeyCode.LeftShift);if(Mathf.Abs(g)>.01f||Mathf.Abs(s)>.01f||n)SetInput(g,s,Input.GetKey(KeyCode.Space)?1:0,n);else if(!Application.isMobilePlatform)SetInput(0,0,0,false);}
 void FixedUpdate(){if(!body)return;Vector3 f=transform.forward;float fs=Vector3.Dot(body.velocity,f);if(throttle>0)body.AddForce(f*throttle*acceleration,ForceMode.Acceleration);else if(throttle<0&&fs>2)body.AddForce(-f*brakeStrength,ForceMode.Acceleration);else if(throttle<0)body.AddForce(f*throttle*reverseAcceleration,ForceMode.Acceleration);if(brake>0)body.velocity=Vector3.Lerp(body.velocity,body.velocity*.90f,brake*.35f);float factor=Mathf.Clamp01(body.velocity.magnitude/5f);if(body.velocity.sqrMagnitude>.5f)body.MoveRotation(body.rotation*Quaternion.Euler(0,steer*steering*factor*Time.fixedDeltaTime*Mathf.Sign(fs==0?1:fs),0));if(boost&&nitro>0&&throttle>0){body.AddForce(f*nitroForce,ForceMode.Acceleration);nitro=Mathf.Max(0,nitro-nitroDrain*Time.fixedDeltaTime);}else nitro=Mathf.Min(100,nitro+nitroRecharge*Time.fixedDeltaTime);Vector3 v=transform.InverseTransformDirection(body.velocity);v.x*=.985f;body.velocity=transform.TransformDirection(v);if(body.velocity.magnitude>maxSpeed)body.velocity=body.velocity.normalized*maxSpeed;}
}
