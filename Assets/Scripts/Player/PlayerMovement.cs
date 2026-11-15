using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class PlayerMovement : MonoBehaviour
{
    public float moveSpeed = 5f;
    public float gravity = -9.81f;

    private CharacterController controller;
    private Vector3 velocity;
    private Vector2 mobileInput;
    private bool mobileInputActive;

    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    // Called by the on-screen joystick while the player is touching it.
    public void SetMobileInput(Vector2 input)
    {
        mobileInput = Vector2.ClampMagnitude(input, 1f);
        mobileInputActive = true;
    }

    public void ClearMobileInput()
    {
        mobileInput = Vector2.zero;
        mobileInputActive = false;
    }

    void Update()
    {
        float horizontal = mobileInputActive
            ? mobileInput.x
            : Input.GetAxis("Horizontal");
        float vertical = mobileInputActive
            ? mobileInput.y
            : Input.GetAxis("Vertical");

        Vector3 move = transform.right * horizontal +
                       transform.forward * vertical;

        controller.Move(move * moveSpeed * Time.deltaTime);

        if (controller.isGrounded && velocity.y < 0)
            velocity.y = -2f;

        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);
    }
}
