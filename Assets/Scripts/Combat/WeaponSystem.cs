using UnityEngine;

public class WeaponSystem : MonoBehaviour
{
    public Camera playerCamera;
    public AmmoSystem ammoSystem;
    public float damage = 25f;
    public float weaponRange = 100f;
    public float fireRate = 0.2f;

    private float nextFireTime;

    void Awake()
    {
        if (ammoSystem == null)
            ammoSystem = GetComponent<AmmoSystem>();
    }

    void Start()
    {
        if (playerCamera == null)
            playerCamera = Camera.main;
    }

    public void Fire()
    {
        if (Time.time < nextFireTime || playerCamera == null)
            return;

        // A weapon without an AmmoSystem remains usable for older test scenes.
        if (ammoSystem != null && !ammoSystem.UseAmmo())
            return;

        nextFireTime = Time.time + fireRate;

        Ray ray = playerCamera.ViewportPointToRay(
            new Vector3(0.5f, 0.5f, 0f)
        );

        if (Physics.Raycast(ray, out RaycastHit hit, weaponRange))
        {
            Health target = hit.collider.GetComponentInParent<Health>();
            if (target != null)
                target.TakeDamage(damage);
        }
    }

    public void Reload()
    {
        if (ammoSystem != null)
            ammoSystem.Reload();
    }

    void Update()
    {
        if (Input.GetButtonDown("Fire1"))
            Fire();

        if (Input.GetKeyDown(KeyCode.R))
            Reload();
    }
}
