
using UnityEngine;

public class WeaponSystem : MonoBehaviour
{
    public Camera playerCamera;
    public float damage = 25f;
    public float weaponRange = 100f;
    public float fireRate = 0.2f;

    private float nextFireTime;

    void Start()
    {
        if (playerCamera == null)
            playerCamera = Camera.main;
    }

    public void Fire()
    {
        if (Time.time < nextFireTime)
            return;

        nextFireTime = Time.time + fireRate;

        if (playerCamera == null)
            return;

        Ray ray = playerCamera.ViewportPointToRay(
            new Vector3(0.5f, 0.5f, 0f)
        );

        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, weaponRange))
        {
            Health target = hit.collider.GetComponentInParent<Health>();

            if (target != null)
            {
                target.TakeDamage(damage);
            }
        }
    }

    void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            Fire();
        }
    }
}
