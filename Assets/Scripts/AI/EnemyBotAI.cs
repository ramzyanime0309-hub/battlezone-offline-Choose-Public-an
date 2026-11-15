
using UnityEngine;
using UnityEngine.AI;

public class EnemyBotAI : MonoBehaviour
{
    public Transform player;
    public float attackRange = 2f;
    public float damage = 10f;
    public float attackRate = 1f;

    private NavMeshAgent agent;
    private Health playerHealth;
    private float nextAttackTime;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();

        if (player != null)
            playerHealth = player.GetComponent<Health>();
    }

    void Update()
    {
        if (player == null || agent == null)
            return;

        float distance = Vector3.Distance(
            transform.position,
            player.position
        );

        if (distance > attackRange)
        {
            if (agent.isOnNavMesh)
            {
                agent.isStopped = false;
                agent.SetDestination(player.position);
            }
        }
        else
        {
            if (agent.isOnNavMesh)
                agent.isStopped = true;

            AttackPlayer();
        }
    }

    void AttackPlayer()
    {
        if (playerHealth == null)
            return;

        if (Time.time >= nextAttackTime)
        {
            playerHealth.TakeDamage(damage);
            nextAttackTime = Time.time + attackRate;
        }
    }
}
