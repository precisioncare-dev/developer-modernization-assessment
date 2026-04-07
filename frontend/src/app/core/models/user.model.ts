export interface User {
  userId: number;
  username: string;
  fullName: string;
  role: 'Admin' | 'Staff' | 'ReadOnly';
  token: string;
  expiresAt: string;
}

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  username: string;
  fullName: string;
  role: string;
  expiresAt: string;
}
