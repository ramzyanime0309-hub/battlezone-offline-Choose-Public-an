using UnityEngine;

// Connect these public methods to Unity UI Button OnClick events.
public class MobileCombatControls : MonoBehaviour
{
    public WeaponSystem weaponSystem;

    public void FireButton()
    {
        if (weaponSystem != null)
            weaponSystem.Fire();
    }

    public void ReloadButton()
    {
        if (weaponSystem != null)
            weaponSystem.Reload();
    }
}
