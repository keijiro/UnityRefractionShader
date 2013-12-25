using UnityEngine;
using System.Collections;

public class ParticleController : MonoBehaviour
{
    public GameObject prefab;
    ParticleSystem.Particle[] particles;
    GameObject[] pool;

    void Start ()
    {
        particles = new ParticleSystem.Particle[particleSystem.maxParticles];
        pool = new GameObject[particleSystem.maxParticles];
        for (var i = 0; i < particleSystem.maxParticles; i++)
        {
            pool[i] = Instantiate (prefab) as GameObject;
        }
    }
    
    void Update ()
    {
        var count = particleSystem.GetParticles (particles);
        for (var i = 0; i < count; i++)
        {
            pool[i].transform.position = particles[i].position;
			pool[i].transform.localRotation = Quaternion.AngleAxis(particles[i].rotation, particles[i].axisOfRotation);
			pool[i].transform.localScale = Vector3.one * particles[i].size;
            pool[i].renderer.enabled = true;
        }
        for (var i = count ; i < pool.Length; i++)
        {
            pool[i].renderer.enabled = false;
        }
    }
}
