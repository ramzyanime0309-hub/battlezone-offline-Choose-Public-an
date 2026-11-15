using UnityEngine;
public class PrototypeBot:MonoBehaviour{
 public Transform target;public float health=100,moveSpeed=2.2f,attackRange=13,attackCooldown=1.5f;float nextAttack;bool dead;
 void Update(){if(dead||!target)return;Vector3 d=target.position-transform.position;d.y=0;float dist=d.magnitude;if(dist>3)transform.position+=d.normalized*moveSpeed*Time.deltaTime;if(d.sqrMagnitude>.1f)transform.rotation=Quaternion.Slerp(transform.rotation,Quaternion.LookRotation(d),Time.deltaTime*5);if(dist<=attackRange&&Time.time>=nextAttack){nextAttack=Time.time+attackCooldown;PrototypePlayer p=target.GetComponent<PrototypePlayer>();if(p)p.TakeDamage(8);}}
 public bool TakeDamage(float n){if(dead)return false;health-=n;if(health>0)return false;dead=true;PrototypeMatch m=FindFirstObjectByType<PrototypeMatch>();if(m)m.BotEliminated();Destroy(gameObject);return true;}
}