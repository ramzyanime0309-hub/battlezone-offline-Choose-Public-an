
using UnityEngine;

public class AmmoSystem : MonoBehaviour
{
    public int magazineSize = 30;
    public int reserveAmmo = 120;

    public int CurrentAmmo { get; private set; }

    void Start()
    {
        CurrentAmmo = magazineSize;
    }

    public bool UseAmmo()
    {
        if (CurrentAmmo <= 0)
            return false;

        CurrentAmmo--;
        return true;
    }

    public void Reload()
    {
        if (CurrentAmmo >= magazineSize || reserveAmmo <= 0)
            return;

        int needed = magazineSize - CurrentAmmo;
        int loaded = Mathf.Min(needed, reserveAmmo);

        CurrentAmmo += loaded;
        reserveAmmo -= loaded;
    }
}
