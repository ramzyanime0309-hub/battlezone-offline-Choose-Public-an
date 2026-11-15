using UnityEngine;
using UnityEngine.UI;

public class HUDController : MonoBehaviour
{
    public Health playerHealth;
    public AmmoSystem ammoSystem;

    public Text healthText;
    public Text botsText;
    public Text ammoText;
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

        if (ammoText != null)
        {
            if (ammoSystem != null)
            {
                ammoText.text = "AMMO: " + ammoSystem.CurrentAmmo +
                    " / " + ammoSystem.reserveAmmo;
            }
            else
            {
                ammoText.text = "AMMO: --";
            }
        }

        int botsRemaining = FindObjectsOfType<EnemyBotAI>().Length;

        if (botsText != null)
            botsText.text = "BOTS LEFT: " + botsRemaining;

        if (messageText != null && playerHealth != null)
        {
            if (playerHealth.currentHealth <= 0)
                messageText.text = "GAME OVER!";
            else if (botsRemaining == 0)
                messageText.text = "VICTORY!";
        }
    }
}
