using UnityEngine;
[RequireComponent(typeof(CharacterController))]
public class PrototypePlayer : MonoBehaviour {
 public float moveSpeed=5f, lookSensitivity=.12f, maxHealth=100f; public Transform cameraPivot; public Camera playerCamera; public int ammo=30,reserveAmmo=120,kills; public float Health{get;private set;}
 CharacterController cc; float pitch; float nextShot; public float fireRate = 0.18f; Vector2 move; int moveId=-1,lookId=-1; Vector2 moveStart,lookPrev;
 void Awake(){cc=GetComponent<CharacterController>();Health=maxHealth;if(!playerCamera)playerCamera=GetComponentInChildren<Camera>();if(!cameraPivot&&playerCamera)cameraPivot=playerCamera.transform;}
 void Update(){ReadTouches();
 #if UNITY_EDITOR || UNITY_STANDALONE
 move=new Vector2(Input.GetAxisRaw("Horizontal"),Input.GetAxisRaw("Vertical"));
 if(Input.GetMouseButton(1)){transform.Rotate(0,Input.GetAxis("Mouse X")*3f,0);pitch=Mathf.Clamp(pitch-Input.GetAxis("Mouse Y")*3f,-75,75);if(cameraPivot)cameraPivot.localEulerAngles=new Vector3(pitch,0,0);}
 if(Input.GetMouseButtonDown(0))Fire();
 #endif
 Vector3 d=transform.right*move.x+transform.forward*move.y;if(d.sqrMagnitude>1)d.Normalize();cc.SimpleMove(d*moveSpeed);}
 void ReadTouches(){if(Input.touchCount==0){moveId=-1;lookId=-1;move=Vector2.zero;return;}for(int i=0;i<Input.touchCount;i++){Touch t=Input.GetTouch(i);if(t.phase==TouchPhase.Began){if(t.position.x<Screen.width*.45f&&moveId<0){moveId=t.fingerId;moveStart=t.position;}else if(t.position.x>=Screen.width*.45f&&lookId<0){lookId=t.fingerId;lookPrev=t.position;}}
 if(t.fingerId==moveId){move=Vector2.ClampMagnitude((t.position-moveStart)/85f,1);if(t.phase==TouchPhase.Ended||t.phase==TouchPhase.Canceled){moveId=-1;move=Vector2.zero;}}
 if(t.fingerId==lookId){if(t.phase==TouchPhase.Moved){Vector2 delta=t.position-lookPrev;transform.Rotate(0,delta.x*lookSensitivity,0);pitch=Mathf.Clamp(pitch-delta.y*lookSensitivity,-75,75);if(cameraPivot)cameraPivot.localEulerAngles=new Vector3(pitch,0,0);lookPrev=t.position;}if(t.phase==TouchPhase.Ended||t.phase==TouchPhase.Canceled)lookId=-1;}}}
 public void Fire(){if(ammo<=0||!playerCamera||Time.time<nextShot)return;nextShot=Time.time+fireRate;ammo--;if(Physics.Raycast(playerCamera.transform.position,playerCamera.transform.forward,out RaycastHit hit,120)){PrototypeBot bot=hit.collider.GetComponentInParent<PrototypeBot>();if(bot && bot.TakeDamage(34))kills++;}}
 public void Reload(){int n=Mathf.Min(30-ammo,reserveAmmo);ammo+=n;reserveAmmo-=n;}
 public void TakeDamage(float n){Health=Mathf.Max(0,Health-n);if(Health<=0){Health=maxHealth;transform.position=new Vector3(0,1,-8);}}
}