using UnityEngine;
using UnityEngine.AI;

public class BotSpawner : MonoBehaviour
{
    [Header("Required references")]
    public GameObject botPrefab;
    public Transform player;
    public Transform[] spawnPoints;

    [Header("Match settings")]
    [Min(0)] public int botsToSpawn = 10;
    public bool spawnOnStart = true;
    public float navMeshSearchRadius = 5f;

    private int successfullySpawned;

    public int SuccessfullySpawned
    {
        get { return successfullySpawned; }
    }

    void Start()
    {
        if (spawnOnStart)
            SpawnBots();
    }

    public void SpawnBots()
    {
        successfullySpawned = 0;

        if (botPrefab == null)
        {
            Debug.LogError("BotSpawner: Assign a bot prefab.");
            RegisterCount();
            return;
        }

        if (player == null)
        {
            Debug.LogError("BotSpawner: Assign the player Transform.");
            RegisterCount();
            return;
        }

        if (spawnPoints == null || spawnPoints.Length == 0)
        {
            Debug.LogError("BotSpawner: Add at least one spawn point.");
            RegisterCount();
            return;
        }

        EnemyBotAI prefabAI = botPrefab.GetComponent<EnemyBotAI>();
        Health prefabHealth = botPrefab.GetComponent<Health>();
        NavMeshAgent prefabAgent = botPrefab.GetComponent<NavMeshAgent>();

        if (prefabAI == null || prefabHealth == null || prefabAgent == null)
        {
            Debug.LogError("BotSpawner: The bot prefab needs EnemyBotAI, Health, and NavMeshAgent components.");
            RegisterCount();
            return;
        }

        for (int i = 0; i < botsToSpawn; i++)
        {
            Transform point = spawnPoints[i % spawnPoints.Length];

            if (point == null)
            {
                Debug.LogWarning("BotSpawner: A spawn point is empty; skipping this bot.");
                continue;
            }

            NavMeshHit hit;
            if (!NavMesh.SamplePosition(point.position, out hit,
                navMeshSearchRadius, NavMesh.AllAreas))
            {
                Debug.LogWarning("BotSpawner: No NavMesh found near spawn point " + point.name + ".");
                continue;
            }

            GameObject bot = Instantiate(botPrefab, hit.position, point.rotation);
            EnemyBotAI botAI = bot.GetComponent<EnemyBotAI>();

            if (botAI == null || bot.GetComponent<Health>() == null ||
                bot.GetComponent<NavMeshAgent>() == null)
            {
                Debug.LogError("BotSpawner: Spawned bot is missing a required component.");
                Destroy(bot);
                continue;
            }

            botAI.player = player;
            successfullySpawned++;
        }

        RegisterCount();
        Debug.Log("BotSpawner created " + successfullySpawned +
            " of " + botsToSpawn + " requested bots.");
    }

    void RegisterCount()
    {
        if (GameManager.Instance != null)
            GameManager.Instance.RegisterSpawnedBots(successfullySpawned);
        else
            Debug.LogWarning("BotSpawner: No GameManager found; bot count was not registered.");
    }
}
