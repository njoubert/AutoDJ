
#pragma once

#include <string>
#include <vector>

#include "cinder/Vector.h"

namespace graph {

typedef std::string ParticleId;
typedef std::shared_ptr<class Spring> SpringPtr;

class Particle {
public:
    Particle(float mass);

    ci::Vec2f& position() { return position_; }
    const ci::Vec2f& position() const { return position_; }
    ci::Vec2f& velocity() { return velocity_; }
    const ci::Vec2f& velocity() const { return velocity_; }
    ci::Vec2f& force() { return force_; }
    const ci::Vec2f& force() const { return force_; }

    float mass() { return mass_; }
    void set_mass(float m) { mass_ = m; }

    float mass_;

    bool is_fixed() { return fixed_; }
    void make_fixed();
    bool is_free() { return !fixed_; }
    void make_free();

    float distance_to(const Particle& p);

    float& age() { return age_; }
    const float& age() const { return age_; }

    void reset();

    const ParticleId& id() const { return id_; }

    bool operator==(const Particle& other) const {
        return other.id() == id_;
    }

    // This does not make a spring, it merely records the springs
    // this node has.
    void add_spring(SpringPtr);
    std::vector<SpringPtr>& springs() { return springs_; }

protected:
    ci::Vec2f position_;
    ci::Vec2f velocity_;
    ci::Vec2f force_;

    float age_;
    bool dead_;

    bool fixed_;

    std::vector<SpringPtr> springs_;

private:
    ParticleId id_;
    ParticleId get_random_id();

};

}