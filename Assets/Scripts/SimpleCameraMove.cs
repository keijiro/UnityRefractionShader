using UnityEngine;
using System.Collections;

public class SimpleCameraMove : MonoBehaviour
{
    public Shaker position;
    public Shaker rotation;
    
    void Update ()
    {
        position.Update (Time.deltaTime);
        rotation.Update (Time.deltaTime);
        transform.localPosition = position.Position;
        transform.localRotation = rotation.YawPitch;
    }
}
