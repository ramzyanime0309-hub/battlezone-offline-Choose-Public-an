
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    public Health playerHealth;
    public int startingBots = 10;

    private int botsRemaining;
    private bool matchEnded;

    void Awake()
    {
        Instance = this;
        botsRemaining = startingBots;
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
        if (matchEnded)
            return;

        botsRemaining--;

        if (botsRemaining <= 0)
        {
            EndMatch(true);
        }
    }

    void EndMatch(bool playerWon)
    {
        matchEnded = true;

        if (playerWon)
        {
            Debug.Log("VICTORY! You won the match!");
        }
        else
        {
            Debug.Log("GAME OVER! You were eliminated.");
        }

        Time.timeScale = 0f;
    }
}
