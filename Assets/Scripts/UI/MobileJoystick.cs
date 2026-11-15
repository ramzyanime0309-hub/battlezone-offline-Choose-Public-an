using UnityEngine;
using UnityEngine.EventSystems;

// Attach this to a UI joystick area with a background and optional handle.
public class MobileJoystick : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
{
    public PlayerMovement playerMovement;
    public RectTransform joystickBackground;
    public RectTransform joystickHandle;
    [Range(0.1f, 1f)]
    public float handleRange = 1f;

    public void OnPointerDown(PointerEventData eventData)
    {
        OnDrag(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (playerMovement == null || joystickBackground == null)
            return;

        if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(
            joystickBackground,
            eventData.position,
            eventData.pressEventCamera,
            out Vector2 localPoint))
            return;

        Vector2 halfSize = joystickBackground.rect.size * 0.5f;
        Vector2 input = new Vector2(
            halfSize.x > 0f ? localPoint.x / halfSize.x : 0f,
            halfSize.y > 0f ? localPoint.y / halfSize.y : 0f
        );

        input = Vector2.ClampMagnitude(input, 1f);
        playerMovement.SetMobileInput(input);

        if (joystickHandle != null)
            joystickHandle.anchoredPosition = new Vector2(
                input.x * halfSize.x * handleRange,
                input.y * halfSize.y * handleRange
            );
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (playerMovement != null)
            playerMovement.ClearMobileInput();

        if (joystickHandle != null)
            joystickHandle.anchoredPosition = Vector2.zero;
    }
}
