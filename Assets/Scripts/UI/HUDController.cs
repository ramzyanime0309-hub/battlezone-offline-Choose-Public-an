
using UnityEngine;
using UnityEngine.UI;

public class HUDController : MonoBehaviour
{
    public Health playerHealth;

    public Text healthText;
    public Text botsText;
    public Text messageText;

    void Start()
    {
        if (messageText != null)
            messageText.text = "";
    }

    void Update()
    {
        if (playerHealth != null && healthText != null)
        {
            healthText.text =
                "HEALTH: " +
                Mathf.CeilToInt(playerHealth.currentHealth);
        }

        int botsRemaining =
            FindObjectsOfType<EnemyBotAI>().Length;

        if (botsText != null)
        {
            botsText.text =
                "BOTS LEFT: " + botsRemaining;
        }

        if (messageText != null && playerHealth != null)
        {
            if (playerHealth.currentHealth <= 0)
            {
                messageText.text = "GAME OVER!";
            }
            else if (botsRemaining == 0)
            {
                messageText.text = "VICTORY!";
            }
        }
    }
}
