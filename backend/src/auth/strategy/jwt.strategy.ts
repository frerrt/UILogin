// backend/src/auth/strategy/jwt.strategy.ts

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

// Interfaces pour le type de payload (le contenu du token)
interface JwtPayload {
  email: string;
  sub: number; // L'ID de l'utilisateur
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') { 
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      // ⭐️ Utilisez le même SECRET que dans auth.module.ts ⭐️
      secretOrKey: 'RocinySuperSecretKey2025!', 
    });
  }

  // Cette méthode est appelée après la validation du token (signature OK, non expiré)
  async validate(payload: JwtPayload) {
    // Dans un vrai projet, on chercherait l'utilisateur dans la base de données ici.
    // Ici, on retourne directement les infos du token.
    if (!payload.sub) {
        throw new UnauthorizedException();
    }
    // Les données retournées ici seront attachées à req.user dans le contrôleur.
    return { userId: payload.sub, email: payload.email }; 
  }
}