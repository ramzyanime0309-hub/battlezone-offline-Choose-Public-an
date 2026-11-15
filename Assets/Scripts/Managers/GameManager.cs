using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    public Health playerHealth;
    public int startingBots = 10;

    private int botsRemaining;
    private bool matchEnded;

    public int BotsRemaining
    {
        get { return botsRemaining; }
    }

    void Awake()
    {
        Instance = this;
        botsRemaining = Mathf.Max(0, startingBots);
    }

    void OnDestroy()
    {
        if (Instance == this)
            Instance = null;
    }

    void Update()
    {
        if (matchEnded)
            return;

        if (playerHealth != null &&
            playerHealth.currentHealth <= 0)
        {
            EndMatch(false);
        }
    }

    public void BotEliminated()
    {
        if (matchEnded || botsRemaining <= 0)
            return;

        botsRemaining--;

        Debug.Log("Bot eliminated. Bots remaining: " + botsRemaining);

        if (botsRemaining == 0)
            EndMatch(true);
    }

    void EndMatch(bool playerWon)
    {
        if (matchEnded)
            return;

        matchEnded = true;

        if (playerWon)
            Debug.Log("VICTORY! You won the match!");
        else
            Debug.Log("GAME OVER! You were eliminated.");

        Time.timeScale = 0f;
    }
}
