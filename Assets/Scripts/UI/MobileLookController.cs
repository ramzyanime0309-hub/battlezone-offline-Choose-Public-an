using UnityEngine;
using UnityEngine.EventSystems;

// Attach to a transparent, raycast-enabled UI panel on the right side of the screen.
public class MobileLookController : MonoBehaviour, IPointerDownHandler, IDragHandler
{
    public Transform lookRoot;
    public Transform pitchPivot;
    public float sensitivity = 0.15f;
    public float minimumPitch = -75f;
    public float maximumPitch = 75f;
    public bool invertY;

    private float currentPitch;

    void Start()
    {
        if (pitchPivot != null)
        {
            currentPitch = pitchPivot.localEulerAngles.x;
            if (currentPitch > 180f)
                currentPitch -= 360f;

            currentPitch = Mathf.Clamp(currentPitch, minimumPitch, maximumPitch);
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        // The first drag delta is handled by OnDrag.
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (lookRoot == null || pitchPivot == null)
            return;

        Vector2 delta = eventData.delta * sensitivity;

        lookRoot.Rotate(Vector3.up, delta.x, Space.World);

        float verticalDelta = invertY ? delta.y : -delta.y;
        currentPitch = Mathf.Clamp(
            currentPitch + verticalDelta,
            minimumPitch,
            maximumPitch
        );

        pitchPivot.localRotation = Quaternion.Euler(currentPitch, 0f, 0f);
    }
}
