# LorentzVectorBase is a dependency of FourVectors but not a direct test-env dep.
# After FourVectors loads, bind its API into Main for test scripts.
function __import_lorentzvectorbase!()
    for (pkgid, mod) in Base.loaded_modules
        if pkgid.name == "LorentzVectorBase"
            for sym in (
                :mass,
                :mass2,
                :pt,
                :pt2,
                :eta,
                :phi,
                :px,
                :py,
                :pz,
                :energy,
                :deltar,
                :deltaphi,
                :deltaeta,
                :transverse_momentum,
                :pseudorapidity,
                :azimuthal_angle,
                :cos_theta,
                :polar_angle,
                :rapidity,
                :mt,
                :mt2,
                :spatial_magnitude,
            )
                if isdefined(mod, sym)
                    Core.eval(Main, :(const $(sym) = $mod.$(sym)))
                end
            end
            return
        end
    end
    error("LorentzVectorBase was not loaded by FourVectors")
end
