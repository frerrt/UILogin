// backend/src/app.module.ts

import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { UsersController } from './users/users.controller'; // ⬅️ IMPORT

@Module({
  imports: [AuthModule],
  controllers: [UsersController], // ⬅️ AJOUTÉ
  providers: [],
})
export class AppModule {}