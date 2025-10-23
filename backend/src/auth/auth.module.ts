// backend/src/auth/auth.module.ts

import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport'; // ⬅️ NÉCESSAIRE
import { JwtStrategy } from './strategy/jwt.strategy'; // ⬅️ NÉCESSAIRE

@Module({
  imports: [
    // 1. IMPORTER PASSPORT MODULE
    PassportModule, 
    JwtModule.register({
      secret: 'RocinySuperSecretKey2025!', 
      signOptions: { expiresIn: '1h' },
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    // 2. FOURNIR LA STRATÉGIE 
    JwtStrategy, 
  ],
})
export class AuthModule {}