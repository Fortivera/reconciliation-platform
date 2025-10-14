export type ReconciliationStatus = "pending" | "matched" | "exception" | "approved" | "rejected"
export type TransactionSource = "bank" | "erp" | "manual"
export type MatchType = "auto" | "manual" | "rule-based"
export type UserRole = "admin" | "reconciler" | "viewer"
export type MatchAlgorithm = "exact" | "fuzzy" | "partial" | "many-to-many"

export interface Transaction {
    id: string
    source: TransactionSource
    date: string
    description: string
    amount: number
    reference: string
    status: ReconciliationStatus
    matchedWith?: string
    createdAt: string
}

export interface ReconciliationMatch {
    id: string
    sourceTransactionId: string
    targetTransactionId: string
    matchType: MatchType
    algorithm?: MatchAlgorithm
    confidence: number
    matchedBy: string
    matchedAt: string
    notes?: string
    approvedBy?: string
    approvedAt?: string
}

export interface MatchingRule {
    id: string
    name: string
    description: string
    enabled: boolean
    priority: number
    conditions: {
        field: string
        operator: "equals" | "contains" | "range"
        value: string | number
    }[]
    tolerance: number
    createdAt: string
    updatedAt: string
}

export interface AuditLog {
    id: string
    action: string
    entityType: "transaction" | "match" | "rule"
    entityId: string
    userId: string
    userName: string
    timestamp: string
    details: Record<string, unknown>
}

export interface User {
    id: string
    email: string
    name: string
    role: UserRole
    avatar?: string
    createdAt: string
}

export interface MatchSuggestion {
    id: string
    sourceTransactionId: string
    targetTransactionId: string
    algorithm: MatchAlgorithm
    confidence: number
    reason: string
    amountDifference: number
    dateDifference: number
    createdAt: string
}

export interface ReconciliationSummary {
    totalTransactions: number
    matched: number
    pending: number
    exceptions: number
    matchRate: number
    totalAmount: number
    matchedAmount: number
    autoMatchRate: number
    timeSavedHours: number
    suggestionsCount: number
}
